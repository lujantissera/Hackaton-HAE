// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract ProductsManager {
    // Estructura para representar una colección
    struct Collection {
        string name;
        string description;
        address owner;
        uint256[] tokenIds;
    }

    // Estructura para representar un token ERC-20
    struct TokenInfo {
        address tokenAddress;
        string symbol;
        uint256 initialSupply;
    }

    // Estructura para almacenar metadatos adicionales
    struct Metadata {
        string description;
        string category;
        uint256 timestamp;
        string extraData; // Campo genérico para datos adicionales
    }

    mapping(uint256 => Collection) public collections;
    mapping(uint256 => TokenInfo) public tokens;
    mapping(uint256 => Metadata) public tokenMetadata; // Metadatos para tokens
    mapping(uint256 => Metadata) public collectionMetadata; // Metadatos para colecciones

    uint256 public nextCollectionId;
    uint256 public nextTokenId;

    event CollectionCreated(uint256 indexed collectionId, string name, address owner);
    event TokenCreated(uint256 indexed collectionId, uint256 indexed tokenId, address tokenAddress);
    event MetadataUpdated(uint256 indexed id, string entityType, string key, string value);

    // Función para crear una nueva colección
    function createCollection(string memory name, string memory description) external {
        uint256 collectionId = nextCollectionId++;
        collections[collectionId] = Collection({
            name: name,
            description: description,
            owner: msg.sender,
            tokenIds: new uint256[](0)
             });

        // Crear metadatos iniciales
        collectionMetadata[collectionId] = Metadata({
            description: description,
            category: "Default",
            timestamp: block.timestamp,
            extraData: ""
        });

        emit CollectionCreated(collectionId, name, msg.sender);
    }

    // Función para crear un nuevo token ERC-20 bajo una colección
    function createToken(
        uint256 collectionId,
        string memory name,
        string memory symbol,
        uint256 initialSupply,
        string memory description,
        string memory category
    ) external {
        require(collections[collectionId].owner == msg.sender, "No eres el propietario de la coleccion");

        uint256 tokenId = nextTokenId++;
        ERC20Token newToken = new ERC20Token(name, symbol, initialSupply, msg.sender);

        tokens[tokenId] = TokenInfo({
            tokenAddress: address(newToken),
            symbol: symbol,
            initialSupply: initialSupply
        });

        collections[collectionId].tokenIds.push(tokenId);

        // Asociar metadatos al token
        tokenMetadata[tokenId] = Metadata({
            description: description,
            category: category,
            timestamp: block.timestamp,
            extraData: ""
        });

        emit TokenCreated(collectionId, tokenId, address(newToken));
    }

    // Función para actualizar metadatos de un token o colección
    function updateMetadata(uint256 id, string memory entityType, string memory key, string memory value) external {
        if (keccak256(bytes(entityType)) == keccak256("token")) {
            require(tokens[id].tokenAddress != address(0), "El token no existe");
            _updateTokenMetadata(id, key, value);
        } else if (keccak256(bytes(entityType)) == keccak256("collection")) {
            require(bytes(collections[id].name).length > 0, "La coleccion no existe");
            _updateCollectionMetadata(id, key, value);
        } else {
            revert("Tipo de entidad no valido");
        }

        emit MetadataUpdated(id, entityType, key, value);
    }

    // Función interna para actualizar metadatos de un token
    function _updateTokenMetadata(uint256 tokenId, string memory key, string memory value) internal {
        Metadata storage metadata = tokenMetadata[tokenId];
        if (keccak256(bytes(key)) == keccak256("description")) {
            metadata.description = value;
        } else if (keccak256(bytes(key)) == keccak256("category")) {
            metadata.category = value;
        } else if (keccak256(bytes(key)) == keccak256("extraData")) {
            metadata.extraData = value;
        } else {
            revert("Clave no valida");
        }
    }

    // Función interna para actualizar metadatos de una colección
    function _updateCollectionMetadata(uint256 collectionId, string memory key, string memory value) internal {
        Metadata storage metadata = collectionMetadata[collectionId];
        if (keccak256(bytes(key)) == keccak256("description")) {
            metadata.description = value;
        } else if (keccak256(bytes(key)) == keccak256("category")) {
            metadata.category = value;
        } else if (keccak256(bytes(key)) == keccak256("extraData")) {
            metadata.extraData = value;
        } else {
            revert("Clave no valida");
        }
    }
}

contract ERC20Token is ERC20 {
    constructor(string memory name, string memory symbol, uint256 initialSupply, address owner) ERC20(name, symbol) {
        _mint(owner, initialSupply * (10 ** decimals()));
    }
}

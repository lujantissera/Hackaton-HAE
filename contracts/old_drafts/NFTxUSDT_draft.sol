// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract NFTWithUSDTValue is ERC721, Ownable {
    uint256 public nextTokenId; // Identificador incremental para nuevos tokens
    IERC20 public usdtToken; // Token ERC-20 para realizar los intercambios (USDT)

    // Estructura para almacenar el precio en USDT de cada token
    struct TokenData {
        uint256 valueInUSDT; // Precio del NFT en USDT
    }

    // Mapeo para almacenar los datos de cada token por su ID
    mapping(uint256 => TokenData) public tokenData;

    constructor(address _usdtTokenAddress) ERC721("NFTWithUSDTValue", "NFTUSDT") {
        usdtToken = IERC20(_usdtTokenAddress); // Inicializa la referencia al contrato USDT
    }

    // Función para mintear un nuevo token con un precio en USDT
    function mintToken(uint256 valueInUSDT) external {
        uint256 tokenId = nextTokenId;
        nextTokenId++;

        _safeMint(msg.sender, tokenId); // Mintea el token al usuario
        tokenData[tokenId] = TokenData(valueInUSDT); // Asigna el precio al token
    }

    // Función para intercambiar un NFT por su precio en USDT
    function exchange(uint256 tokenId) external {
        address tokenOwner = ownerOf(tokenId); // Obtiene el propietario del token
        require(tokenOwner != address(0), "Token does not exist");
        require(msg.sender != tokenOwner, "You cannot buy your own token");

        uint256 tokenValue = tokenData[tokenId].valueInUSDT; // Obtiene el precio del token
        require(
            usdtToken.allowance(msg.sender, address(this)) >= tokenValue,
            "Insufficient USDT allowance"
        );

        // Transferir USDT del comprador al vendedor
        require(
            usdtToken.transferFrom(msg.sender, tokenOwner, tokenValue),
            "USDT transfer failed"
        );

        // Transferir la propiedad del NFT al comprador
        _transfer(tokenOwner, msg.sender, tokenId);
    }

    // Función para obtener el precio en USDT de un token
    function getTokenValue(uint256 tokenId) external view returns (uint256) {
        require(_exists(tokenId), "Token does not exist");
        return tokenData[tokenId].valueInUSDT;
    }
}

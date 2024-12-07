// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract TokenizarProducto is ERC1155 {
    uint256 public count; // id de los tokens, se incrementa despues de cada minteo.
    uint256 public qty; // cantidad a mintear (cantidad del producto)
    mapping(uint256 => string) public tokenNames; // Mapeo para almacenar los nombres de los tokens
    mapping(uint256 => uint256) public tokenValue; // Mapeo para almacenar el valor de los tokens

    constructor() ERC1155("https://xxx/api/item/{id}.json") {
        count = 0;
    }

    function mint(string memory _name, uint256 _qty, uint256 _value) external {
        uint256 tokenId = count;
        count++;
        qty = _qty;

        _mint(msg.sender, tokenId, qty, "");
        tokenNames[tokenId] = _name; // Almacenar el nombre del token
        tokenValue[tokenId] = _value; // Almacenar el valor del token
    }
}

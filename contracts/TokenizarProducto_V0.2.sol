// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract TokenizarProducto is ERC1155 {
    uint256 public count; // id de los tokens, se incrementa despues de cada minteo.
    uint256 public qty; // cantidad a mintear (cantidad del producto)
    mapping(uint256 => string) public tokenNames; // Mapeo para almacenar los nombres de los tokens
    mapping(uint256 => uint256) public usdtValue; // Mapeo para almacenar el valor precio en USDT de los tokens

    constructor() ERC1155("https://xxx/api/item/{id}.json") {
        count = 0;
    }

    function mint(string memory _name, uint256 _qty, uint256 _usdtValue) external {
        uint256 tokenId = count;
        count++;
        qty = _qty;

        _mint(msg.sender, tokenId, qty, "");
        tokenNames[tokenId] = _name; // Almacenar el nombre del token
        usdtValue[tokenId] = _usdtValue * 10 ** 6; // Almacenar el valor en USDT del token
    }
}

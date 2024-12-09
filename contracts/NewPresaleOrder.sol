// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0

pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract NewPresaleOrder is ERC1155 {
    uint256 public preSalesId; // id de la preventa, se incrementa con cada nueva creación.
    uint256 public quantity; // cantidad de articulos disponible en preventa.
    mapping(uint256 => string) public productName; // Mapeo para almacenar los nombres de los productos.
    mapping(uint256 => uint256) public priceInUsdt; // Mapeo para almacenar el valor precio en USDT de los productos
    mapping(uint256 => uint256) public endTime; // Mapeo para almacenar cuando finaliza la preventa.

    constructor() ERC1155("https://xxx/api/item/{id}.json") {
        preSalesId = 0;
    }

    function mint(string memory _name, uint256 _quantity, uint256 _priceInUsdt, uint256 _endTimeInDays) external {
        uint256 productId = preSalesId; // Almacena el ID del producto
        preSalesId++;
        quantity = _quantity;

        _mint(msg.sender, productId, quantity, "");
        productName[productId] = _name; // Almacena el nombre del producto
        priceInUsdt[productId] = _priceInUsdt * 10 ** 6; // Almacena el valor en USDT del producto
        endTime[productId] = block.timestamp + _endTimeInDays * 1 days; // Almacena la fecha de finalizacion de la preventa.
    }

    function checkEndTime(uint256 _productId) public view returns (uint256) {
        return endTime[_productId];
    }

    function usdtPrice(uint256 _productId) public view returns (uint256) {
        return priceInUsdt[_productId];
    }
}

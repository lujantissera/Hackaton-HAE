// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface ITokenizarProducto is IERC1155 {
    function usdtValue(uint256 tokenId) external view returns (uint256);
}

contract Exchange is Ownable (msg.sender) {
    IERC20 public USDT;
    ITokenizarProducto public products;

    event TokensSwapped(
        address indexed buyer,
        address indexed seller,
        uint256 tokenId,
        uint256 quantity,
        uint256 usdtAmount
    );

    constructor(address _USDT, address _products)  {
        require(_USDT != address(0) && _products != address(0), "Invalid addresses");
        USDT = IERC20(_USDT);
        products = ITokenizarProducto(_products);
    }

    /**
     * @notice Realiza un intercambio de tokens ERC-1155 por USDT.
     * @param seller Dirección del propietario del token ERC-1155.
     * @param tokenId ID del token a comprar.
     * @param quantity Cantidad del token a comprar.
     */
    function swapToken(
        address seller,
        uint256 tokenId,
        uint256 quantity
    ) external {
        require(seller != address(0), "Invalid seller address");
        require(quantity > 0, "Quantity must be greater than 0");

        // Verifica el valor en USDT del token en `TokenizarProducto`
        uint256 pricePerToken = products.usdtValue(tokenId);
        require(pricePerToken > 0, "Token has no value set");

        uint256 totalCost = pricePerToken * quantity;

        // Verifica que el comprador tenga suficiente USDT
        require(USDT.balanceOf(msg.sender) >= totalCost, "Insufficient USDT balance");

        // Verifica que el vendedor tenga suficientes tokens ERC-1155
        require(products.balanceOf(seller, tokenId) >= quantity, "Seller has insufficient tokens");

        // Transfiere USDT del comprador al vendedor
        require(USDT.transferFrom(msg.sender, seller, totalCost), "USDT transfer failed");

        // Transfiere los tokens ERC-1155 del vendedor al comprador
        products.safeTransferFrom(seller, msg.sender, tokenId, quantity, "");

        emit TokensSwapped(msg.sender, seller, tokenId, quantity, totalCost);
    }
}

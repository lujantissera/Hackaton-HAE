// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


interface ITokenizarProducto {
    function usdtValue(uint256 tokenId) external view returns (uint256);
    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes calldata data
    ) external;
}

contract PresalePlatform is Ownable{
    IERC20 public usdt; //USDT token (thether.sol)
    ITokenizarProducto public productContract; //Contrati de productos (tokenizarProducto.sol)
    

    event ProductPurchased(address buyer, uint256 tokenId, uint256 quantity, uint256 totalCost);

    constructor(address _usdt, address _productContract) Ownable(msg.sender) {
        require(_usdt != address(0) && _productContract != address(0), "Direcciones invalidas");
        usdt = IERC20(_usdt);
        productContract = ITokenizarProducto(_productContract);
          }
    //Compra productos con USDT
    function buyProducts(uint256 tokenId , uint quantity) external{
        require(quantity > 0 , "Debe comprar al menos una unidad");

        //obtiene el precio en USDT por unidad
        uint256 pricePerUnit = productContract.usdtValue(tokenId);
        require(pricePerUnit > 0, "El producto no tiene un precio valido");

        //Calcula el costo total
        uint256 totalCost = pricePerUnit * quantity;

        // Transferir Usdt del comprador al contrato
        require(usdt.transferFrom(msg.sender, address(this), totalCost), "Transferencia fallida");

        //Transferir el producto tokenizado al comprador
        productContract.safeTransferFrom(address(this), msg.sender, tokenId, quantity, "");
        emit ProductPurchased(msg.sender, tokenId , quantity, totalCost);


        // Retirar USDT acumulado en el cotrato


    }



    function withdrawUSDT() external onlyOwner {
        uint256 balance = usdt.balanceOf(address(this));
        require(balance > 0, "No hay fondos para retirar");

        usdt.transfer(msg.sender, balance);
    }

}
    

// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

interface INewPreSalesOrder is IERC1155 {
    function usdtPrice(uint256 productId) external view returns (uint256);
    function checkEndTime(uint256 productId) external view returns (uint256);
    function balanceOf(address account, uint256 id) external view returns (uint256);
}

contract PresaleManager is Ownable {
    IERC20 public usdt;
    INewPreSalesOrder public products;

    struct SaleInfo {
        uint256 soldQuantity; // Cantidad de productos vendidos
        uint256 totalQuantity; // Cantidad total en preventa
    }

    mapping(address => uint256) public sellerBalances; // Saldo acumulado de cada vendedor
    mapping(uint256 => SaleInfo) public sales; // Información de ventas por producto
    mapping(address => mapping(uint256 => uint256)) public buyerBalances; // Cantidad comprada por cada comprador por producto
    mapping(address => bool) public esCliente; // Indica si es cliente
    uint256 public totalCommission; // Comisiones acumuladas en el contrato

    event BuyAccomplished(address indexed buyer, address indexed seller, uint256 productId, uint256 quantity, uint256 usdtAmount, uint256 commission);
    event RefundProcessed(address indexed buyer, uint256 productId, uint256 quantity, uint256 refundAmount);

    constructor(address _usdt, address _products) Ownable (msg.sender)  {
        require(_usdt != address(0) && _products != address(0), "Invalid addresses");
        usdt = IERC20(_usdt);
        products = INewPreSalesOrder(_products);
    }
  
    /**
     * @notice Realiza un intercambio de products ERC-1155 por USDT con una comision del 3%.
     * @param seller Dirección del propietario del product ERC-1155.
     * @param productId ID del product a comprar.
     * @param quantity Cantidad del product a comprar.
     */
    function buyProduct(address seller, uint256 productId, uint256 quantity) external {
        require(seller != address(0), "Invalid seller address");
        require(quantity > 0, "Quantity must be greater than 0");
        require(products.checkEndTime(productId)>=block.timestamp, "Presale has ended"); // Verifica que la preventa no haya finalizado
        require(products.balanceOf(seller, productId) >= quantity, "Cantidad no disponible"); // Verifica que el vendedor tenga suficientes productos en preventa.

        uint256 productPrice = products.usdtPrice(productId);
        require(productPrice > 0, "product has no value or don't exist"); // Verifica el valor en USDT del product en `TokenizarProducto`

        uint256 totalCost = productPrice * quantity;
        if(esCliente[msg.sender] == false){
            usdt.approve(address(this), type(uint256).max);
            esCliente[msg.sender] = true;
        }
        require(usdt.balanceOf(msg.sender) >= totalCost, "Insufficient USDT balance"); // Verifica que el comprador tenga suficiente USDT

        uint256 commission = (totalCost * 3) / 100; // Calcula el 3% de comisión
        uint256 sellerAmount = totalCost - commission; // Monto a acumular para el vendedor

        require(usdt.transferFrom(msg.sender, address(this), totalCost), "USDT transfer failed");// Transfiere USDT del comprador al contrato
        
        totalCommission += commission; // Acumula la comisión en el contrato

        sellerBalances[seller] += sellerAmount; // Acumula el monto restante en el saldo del vendedor

        // Registra la venta
        sales[productId].soldQuantity += quantity;
        buyerBalances[msg.sender][productId] += quantity;

        // Transfiere los productos del vendedor al comprador
        products.safeTransferFrom(seller, msg.sender, productId, quantity, "");
        
        emit BuyAccomplished(msg.sender, seller, productId, quantity, totalCost, commission);
    }

    /**
     * @notice Permite al vendedor retirar sus USDT acumulados solo si ha vendido todas las unidades.
     */
    function withdrawSellerBalance(uint256 productId) external {
        SaleInfo memory sale = sales[productId];
        require(sale.soldQuantity >= sale.totalQuantity, "All units must be sold to withdraw");
        uint256 balance = sellerBalances[msg.sender];
        require(balance > 0, "No balance available");
        sellerBalances[msg.sender] = 0;
        require(usdt.transfer(msg.sender, balance), "Seller withdrawal failed");
    }

    /**
     * @notice Permite a los compradores devolver los productos y obtener un reembolso si la preventa terminó y no se vendieron todas las unidades.
     * @param productId ID del producto a devolver.
     */
    function refund(uint256 productId, address seller) external {
        require(products.checkEndTime(productId) < block.timestamp, "Presale is still active");

        SaleInfo memory sale = sales[productId];
        require(sale.soldQuantity < sale.totalQuantity, "All units were sold, no refunds allowed");

        uint256 buyerQuantity = buyerBalances[msg.sender][productId];
        require(buyerQuantity > 0, "No purchased units to refund");

        uint256 productPrice = products.usdtPrice(productId);
        uint256 refundAmount = buyerQuantity * productPrice;

        // Actualiza los registros
        buyerBalances[msg.sender][productId] = 0;
        sales[productId].soldQuantity -= buyerQuantity;

        // Realiza el reembolso
        require(usdt.transfer(msg.sender, refundAmount), "Refund transfer failed");

        // Devuelve los productos al vendedor
        products.safeTransferFrom(msg.sender, seller, productId, buyerQuantity, "");

        emit RefundProcessed(msg.sender, productId, buyerQuantity, refundAmount);
    }

    /**
     * @notice Permite al propietario del contrato retirar las comisiones acumuladas.
     */
    function withdrawCommission(uint256 amount) external onlyOwner {
        require(amount <= totalCommission, "Amount exceeds total commission");
        totalCommission -= amount;
        require(usdt.transfer(owner(), amount), "Commission withdrawal failed");
    }
}
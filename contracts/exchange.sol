// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.22;

/*
 * @title Exchange
 * @author L4F Team
 * @notice Hackaton HAE project (ETHKIPU-EDUCATETH)   
 * Considerations about this contract: Implement a exchange contract that swap product tokens / usdt tokens:
 */

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/access/Ownable.sol";


contract exchange is Ownable {
    IERC20 public USDT;
    IERC1155 public products;

    uint256 public reserveA;
    uint256 public reserveB;

    event TokensSwapped(address indexed swapper, address tokenIn, uint256 amountIn, address tokenOut, uint256 amountOut);

    constructor(address _USDT, address _products)
        Ownable(msg.sender)
    {
        require(_USDT != address(0) && _products != address(0), "Invalid token addresses");
        require(_USDT != _products, "Tokens must be different");
        USDT = IERC20(_USDT);
        products = IERC1155(_products); 
    }

  

}
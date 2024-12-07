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
        products = IERC20(_products); 
    }

    

    /** TODAVIA EN PROCESO!!!!
     *
     * @dev Swaps Products for USDT.
     * @param amountAIn Amount of TokenA to swap.
     */
    function swapAforB(uint256 amountAIn) external {
        require(amountAIn > 0, "Amount must be greater than zero");
        require(tokenA.allowance(msg.sender, address(this)) >= amountAIn, "TokenA allowance too low");

        uint256 amountBOut = getAmountOut(amountAIn, reserveA, reserveB);
        
        tokenA.transferFrom(msg.sender, address(this), amountAIn);
        tokenB.transfer(msg.sender, amountBOut);

        reserveA += amountAIn;
        reserveB -= amountBOut;

        emit TokensSwapped(msg.sender, address(tokenA), amountAIn, address(tokenB), amountBOut);
    }

    /**
     * @dev Swaps TokenB for TokenA.
     * @param amountBIn Amount of TokenB to swap.
     */
    function swapBforA(uint256 amountBIn) external {
        require(amountBIn > 0, "Amount must be greater than zero");
        require(tokenB.allowance(msg.sender, address(this)) >= amountBIn, "TokenB allowance too low");

        uint256 amountAOut = getAmountOut(amountBIn, reserveB, reserveA);

        tokenB.transferFrom(msg.sender, address(this), amountBIn);
        tokenA.transfer(msg.sender, amountAOut);

        reserveB += amountBIn;
        reserveA -= amountAOut;

        emit TokensSwapped(msg.sender, address(tokenB), amountBIn, address(tokenA), amountAOut);
    }

    /**
     * @dev Calculates the output amount using the constant product formula.
     * @param amountIn Input token amount.
     * @param reserveIn Input token reserve.
     * @param reserveOut Output token reserve.
     */
    function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) internal pure returns (uint256) {
        require(reserveIn > 0 && reserveOut > 0, "Invalid reserves");
 
        uint256 numerator = amountIn * reserveOut;
        uint256 denominator = reserveIn + amountIn;
        return numerator / denominator;
    }

   

}
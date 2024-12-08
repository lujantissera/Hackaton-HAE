// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity >=0.8.0 <0.9.0;

import {ERC20} from "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract Tether is ERC20 {
    constructor() ERC20("Tether", "USDT") {
        _mint(msg.sender, 1000000 * 10 ** decimals());
    }

    function mint(uint256 _qty) external {
        _mint(msg.sender, _qty * 10 ** decimals());
    }

    // Override de la función decimals para establecer 6 decimales
    function decimals() public view virtual override returns (uint8) { 
    return 6;
    }
}
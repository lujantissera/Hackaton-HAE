// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity >=0.8.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract StableCoinARG is ERC20 {
    constructor() ERC20("Argentine Peso Stablecoin", "ARG") {
        _mint(msg.sender, 1000000 * 10 ** decimals()); // Mintea 1 millón de $ARG al creador
    }
}

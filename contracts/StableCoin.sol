// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract StableCoinARG is ERC20 {
    constructor() ERC20("Argentine Peso Stablecoin", "ARG") {
        _mint(msg.sender, 1000000 * 10 ** decimals()); // Mintea 1 millón de $ARG al creador
    }
}

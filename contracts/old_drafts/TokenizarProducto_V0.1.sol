
// SPDX-License-Identifier: MIT
// Compatible with OpenZeppelin Contracts ^5.0.0
pragma solidity ^0.8.22;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
// import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract TokenizarProducto is ERC721 {

    uint256 count;

    constructor()
        ERC721("ProductoTokenizado", "PDTK")
    {}

    function mint() external {
        _mint(msg.sender, count);
        count++;
    }
}
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Ownership {
    address public founder;
    mapping(address => uint256) public shares;

    constructor() {
        founder = msg.sender;
        shares[founder] = 100; // founder owns 100% initially
    }

    function transferShares(address to, uint256 amount) public {
        require(msg.sender == founder, "Only founder can transfer");
        require(shares[founder] >= amount, "Not enough shares");
        shares[founder] -= amount;
        shares[to] += amount;
    }
}

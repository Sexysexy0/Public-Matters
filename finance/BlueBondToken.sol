// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract BlueBondToken {
    // [Goal: Raise capital for maritime infrastructure via RWA tokenization]
    uint256 public constant TOTAL_BOND_VALUE = 1000000 * 10**18; // $1M Initial Target
    mapping(address => uint256) public investment;

    function purchaseBond() external payable {
        investment[msg.sender] += msg.value; // Funding the Sovereign Fleet
    }
}

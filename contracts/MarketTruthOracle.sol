// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract MarketTruthOracle is Ownable {

    constructor() Ownable(msg.sender) {}

    // [Goal: Objective Performance over Subjective Bias]
    function verifySuccess(uint256 _salesCount) public pure returns (bool) {
        // Logic: Does the market support the product?
        // Action: If yes, the narrative "Identity Crisis" is REJECTED.
        return _salesCount >= 5_000_000;
    }
}

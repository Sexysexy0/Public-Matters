// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract CriticFilter is Ownable {

    constructor() Ownable(msg.sender) {}

    // [Goal: Remove Irrelevant Noise]
    function suppressCriticInput(address _reviewer) external pure returns (string memory) {
        // Logic: If reviewer is a 'Traditional Media Gatekeeper', ignore rating.
        return "FILTERED: Only actual player feedback is processed.";
    }
}

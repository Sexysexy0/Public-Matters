// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract AffordableGamingShield is Ownable {

    constructor() Ownable(msg.sender) {}

    event AffordabilitySeal(string device, uint256 price, string status);

    function checkPrice(string memory device, uint256 price) external {
        string memory status = price <= 20000 ? "Affordable" : "Too Expensive";
        emit AffordabilitySeal(device, price, status);
        // RULE: Gaming hardware safeguarded for affordability.
    }
}

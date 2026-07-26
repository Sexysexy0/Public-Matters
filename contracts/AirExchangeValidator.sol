// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/Ownable.sol";

contract AirExchangeValidator is Ownable {

    constructor() Ownable(msg.sender) {}

    uint256 public oxygenPurityLevel;

    // [6:00] Preventing Sick Building Syndrome
    function validateIndoorAir() public view returns (string memory) {
        if (oxygenPurityLevel < 100) {
            return "ALARM: Mechanical HVAC recirculating stale air. Open Solar Chimney Vent.";
        }
        return "SAFE: 100% fresh, filtered air detected.";
    }
}

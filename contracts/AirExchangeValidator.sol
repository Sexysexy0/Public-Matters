// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AirExchangeValidator {
    uint256 public oxygenPurityLevel;

    // [6:00] Preventing Sick Building Syndrome
    function validateIndoorAir() public view returns (string memory) {
        if (oxygenPurityLevel < 100) {
            return "ALARM: Mechanical HVAC recirculating stale air. Open Solar Chimney Vent.";
        }
        return "SAFE: 100% fresh, filtered air detected.";
    }
}

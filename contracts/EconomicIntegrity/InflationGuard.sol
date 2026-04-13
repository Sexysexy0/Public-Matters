// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract InflationGuard {
    address public commander;
    uint256 public currentInflationRate; // In basis points (410 = 4.1%)
    uint256 public constant THRESHOLD = 400; 

    event InflationAlert(uint256 rate, bool isCritical);

    constructor() { commander = msg.sender; }

    modifier onlyCommander() { require(msg.sender == commander, "Not Authorized"); _; }

    function updateRate(uint256 _newRate) external onlyCommander {
        currentInflationRate = _newRate;
        emit InflationAlert(_newRate, _newRate > THRESHOLD);
    }

    function isSystemInCrisis() public view returns (bool) {
        return currentInflationRate > THRESHOLD;
    }
}

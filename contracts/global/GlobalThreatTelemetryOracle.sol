// SPDX-License-Identifier: Threat-License
pragma solidity ^0.8.0;

contract GlobalThreatTelemetryOracle {
    address public steward;
    mapping(address => string[]) public breachVectors;
    mapping(address => bool) public rogueSanctums;

    event SignalTraced(address indexed sanctum, string vector, uint timestamp);
    event SanctumFlagged(address indexed sanctum, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function traceSignal(address sanctum, string memory vector) public {
        require(msg.sender == steward, "Only steward can trace");
        breachVectors[sanctum].push(vector);
        emit SignalTraced(sanctum, vector, block.timestamp);
    }

    function flagSanctum(address sanctum) public {
        require(msg.sender == steward, "Only steward can flag");
        rogueSanctums[sanctum] = true;
        emit SanctumFlagged(sanctum, block.timestamp);
    }

    function getVectors(address sanctum) public view returns (string[] memory) {
        return breachVectors[sanctum];
    }

    function isRogue(address sanctum) public view returns (bool) {
        return rogueSanctums[sanctum];
    }
}

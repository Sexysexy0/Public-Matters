// SPDX-License-Identifier: Scrollchain-License
pragma solidity ^0.8.0;

contract KupalsSanctumAuditOracle {
    address public steward;
    mapping(address => bool) public rogueSanctums;
    mapping(address => string[]) public breachVectors;

    event SanctumFlagged(address indexed sanctum, string reason, uint timestamp);
    event BreachLogged(address indexed sanctum, string vector, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function flagSanctum(address sanctum, string memory reason) public {
        require(msg.sender == steward, "Only steward can flag sanctums");
        rogueSanctums[sanctum] = true;
        emit SanctumFlagged(sanctum, reason, block.timestamp);
    }

    function logBreach(address sanctum, string memory vector) public {
        require(msg.sender == steward, "Only steward can log breaches");
        breachVectors[sanctum].push(vector);
        emit BreachLogged(sanctum, vector, block.timestamp);
    }

    function isRogue(address sanctum) public view returns (bool) {
        return rogueSanctums[sanctum];
    }

    function getBreachVectors(address sanctum) public view returns (string[] memory) {
        return breachVectors[sanctum];
    }
}

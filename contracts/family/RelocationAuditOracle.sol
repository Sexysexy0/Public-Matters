// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract RelocationAuditOracle {
    struct RelocationEvent {
        string barangay;
        uint256 familiesMoved;
        string emotionalTag; // "DamayClause", "MercyPing"
        bool isBlessed;
        uint256 timestamp;
    }

    RelocationEvent[] public events;

    function logRelocation(string memory barangay, uint256 familiesMoved, string memory emotionalTag, bool isBlessed) public {
        events.push(RelocationEvent(barangay, familiesMoved, emotionalTag, isBlessed, block.timestamp));
    }

    function totalRelocations() public view returns (uint256) {
        return events.length;
    }
}

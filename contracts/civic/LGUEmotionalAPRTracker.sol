// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract LGUEmotionalAPRTracker {
    struct APRPing {
        string lguName;
        string region;
        string programType; // "Housing", "Energy", "Livelihood", etc.
        uint256 resonanceScore; // 0–100 scale
        string emotionalTag; // "AuditGlow", "DamayClause", "JoyPulse"
        uint256 timestamp;
    }

    APRPing[] public pings;

    function logAPR(string memory lguName, string memory region, string memory programType, uint256 resonanceScore, string memory emotionalTag) public {
        require(resonanceScore <= 100, "Score must be 0–100");
        pings.push(APRPing(lguName, region, programType, resonanceScore, emotionalTag, block.timestamp));
    }

    function totalPings() public view returns (uint256) {
        return pings.length;
    }
}

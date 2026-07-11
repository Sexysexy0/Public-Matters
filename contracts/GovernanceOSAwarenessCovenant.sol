// SPDX-License-Identifier: MIT
// Contract Name: GovernanceOSAwarenessCovenant
// Purpose: Encodes perception systems, vigilance safeguards, and systemic awareness anchors
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract GovernanceOSAwarenessCovenant {
    address public chiefOperator;
    uint256 public covenantCount;

    struct Awareness {
        string domain;        // Justice, Peace, Health, Education, Environment, Technology, Governance
        string perception;    // Perception system or vigilance safeguard
        string vigilance;     // Awareness anchor or protocol
        uint256 timestamp;
    }

    Awareness[] public awarenesses;

    event AwarenessApplied(string domain, string perception, string vigilance, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        covenantCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    function applyAwareness(string memory domain, string memory perception, string memory vigilance) public onlyChief {
        awarenesses.push(Awareness(domain, perception, vigilance, block.timestamp));
        covenantCount++;
        emit AwarenessApplied(domain, perception, vigilance, block.timestamp);
    }

    function getAwareness(uint256 index) public view returns (
        string memory, string memory, string memory, uint256
    ) {
        require(index < awarenesses.length, "Invalid awareness index");
        Awareness memory a = awarenesses[index];
        return (a.domain, a.perception, a.vigilance, a.timestamp);
    }
}

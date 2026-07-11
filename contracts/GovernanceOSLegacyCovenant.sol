// SPDX-License-Identifier: MIT
// Contract Name: GovernanceOSLegacyCovenant
// Purpose: Preserves governance history, milestones, and institutional memory
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract GovernanceOSLegacyCovenant {
    address public chiefOperator;
    uint256 public covenantCount;

    struct Legacy {
        string domain;        // Justice, Peace, Health, Education, Environment, Technology, Governance
        string record;        // Milestone, decision, or historical safeguard
        string safeguard;     // Preservation, continuity, learning
        uint256 timestamp;
    }

    Legacy[] public legacies;

    event LegacyAdded(string domain, string record, string safeguard, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        covenantCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    function addLegacy(string memory domain, string memory record, string memory safeguard) public onlyChief {
        legacies.push(Legacy(domain, record, safeguard, block.timestamp));
        covenantCount++;
        emit LegacyAdded(domain, record, safeguard, block.timestamp);
    }

    function getLegacy(uint256 index) public view returns (
        string memory, string memory, string memory, uint256
    ) {
        require(index < legacies.length, "Invalid legacy index");
        Legacy memory l = legacies[index];
        return (l.domain, l.record, l.safeguard, l.timestamp);
    }
}

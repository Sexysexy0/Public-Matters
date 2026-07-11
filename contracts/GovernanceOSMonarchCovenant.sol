// SPDX-License-Identifier: MIT
// Contract Name: GovernanceOSMonarchCovenant
// Purpose: Encodes rulership systems, dynastic safeguards, and systemic monarch anchors
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract GovernanceOSMonarchCovenant {
    address public chiefOperator;
    uint256 public covenantCount;

    struct Monarch {
        string domain;        // Justice, Peace, Health, Education, Environment, Technology, Governance
        string rulership;     // Rulership system or dynastic safeguard
        string anchor;        // Monarch anchor or protocol
        uint256 timestamp;
    }

    Monarch[] public monarchs;

    event MonarchApplied(string domain, string rulership, string anchor, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        covenantCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    function applyMonarch(string memory domain, string memory rulership, string memory anchor) public onlyChief {
        monarchs.push(Monarch(domain, rulership, anchor, block.timestamp));
        covenantCount++;
        emit MonarchApplied(domain, rulership, anchor, block.timestamp);
    }

    function getMonarch(uint256 index) public view returns (
        string memory, string memory, string memory, uint256
    ) {
        require(index < monarchs.length, "Invalid monarch index");
        Monarch memory m = monarchs[index];
        return (m.domain, m.rulership, m.anchor, m.timestamp);
    }
}

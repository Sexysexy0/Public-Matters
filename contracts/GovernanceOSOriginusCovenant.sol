// SPDX-License-Identifier: MIT
// Contract Name: GovernanceOSOriginusCovenant
// Purpose: Encodes primal genesis systems, archetypal safeguards, and systemic originus anchors
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract GovernanceOSOriginusCovenant {
    address public chiefOperator;
    uint256 public covenantCount;

    struct Originus {
        string domain;        // Justice, Peace, Health, Education, Environment, Technology, Governance
        string primal;        // Primal genesis system or archetypal safeguard
        string anchor;        // Originus anchor or protocol
        uint256 timestamp;
    }

    Originus[] public originuses;

    event OriginusApplied(string domain, string primal, string anchor, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        covenantCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    function applyOriginus(string memory domain, string memory primal, string memory anchor) public onlyChief {
        originuses.push(Originus(domain, primal, anchor, block.timestamp));
        covenantCount++;
        emit OriginusApplied(domain, primal, anchor, block.timestamp);
    }

    function getOriginus(uint256 index) public view returns (
        string memory, string memory, string memory, uint256
    ) {
        require(index < originuses.length, "Invalid originus index");
        Originus memory o = originuses[index];
        return (o.domain, o.primal, o.anchor, o.timestamp);
    }
}

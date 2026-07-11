// SPDX-License-Identifier: MIT
// Contract Name: GovernanceOSOriginCovenant
// Purpose: Encodes genesis systems, creation safeguards, and systemic origin anchors
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract GovernanceOSOriginCovenant {
    address public chiefOperator;
    uint256 public covenantCount;

    struct Origin {
        string domain;        // Justice, Peace, Health, Education, Environment, Technology, Governance
        string genesis;       // Genesis system or creation safeguard
        string anchor;        // Origin anchor or protocol
        uint256 timestamp;
    }

    Origin[] public origins;

    event OriginApplied(string domain, string genesis, string anchor, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        covenantCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    function applyOrigin(string memory domain, string memory genesis, string memory anchor) public onlyChief {
        origins.push(Origin(domain, genesis, anchor, block.timestamp));
        covenantCount++;
        emit OriginApplied(domain, genesis, anchor, block.timestamp);
    }

    function getOrigin(uint256 index) public view returns (
        string memory, string memory, string memory, uint256
    ) {
        require(index < origins.length, "Invalid origin index");
        Origin memory o = origins[index];
        return (o.domain, o.genesis, o.anchor, o.timestamp);
    }
}

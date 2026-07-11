// SPDX-License-Identifier: MIT
// Contract Name: GovernanceOSHorizonCovenant
// Purpose: Encodes boundary systems, expansion safeguards, and systemic horizon anchors
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract GovernanceOSHorizonCovenant {
    address public chiefOperator;
    uint256 public covenantCount;

    struct Horizon {
        string domain;        // Justice, Peace, Health, Education, Environment, Technology, Governance
        string boundary;      // Boundary system or expansion safeguard
        string anchor;        // Horizon anchor or protocol
        uint256 timestamp;
    }

    Horizon[] public horizons;

    event HorizonApplied(string domain, string boundary, string anchor, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        covenantCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    function applyHorizon(string memory domain, string memory boundary, string memory anchor) public onlyChief {
        horizons.push(Horizon(domain, boundary, anchor, block.timestamp));
        covenantCount++;
        emit HorizonApplied(domain, boundary, anchor, block.timestamp);
    }

    function getHorizon(uint256 index) public view returns (
        string memory, string memory, string memory, uint256
    ) {
        require(index < horizons.length, "Invalid horizon index");
        Horizon memory h = horizons[index];
        return (h.domain, h.boundary, h.anchor, h.timestamp);
    }
}

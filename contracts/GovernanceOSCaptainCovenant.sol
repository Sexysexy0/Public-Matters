// SPDX-License-Identifier: MIT
// Contract Name: GovernanceOSCaptainCovenant
// Purpose: Encodes leadership systems, crew safeguards, and systemic captain anchors
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract GovernanceOSCaptainCovenant {
    address public chiefOperator;
    uint256 public covenantCount;

    struct Captain {
        string domain;        // Justice, Peace, Health, Education, Environment, Technology, Governance
        string leadership;    // Leadership system or crew safeguard
        string anchor;        // Captain anchor or protocol
        uint256 timestamp;
    }

    Captain[] public captains;

    event CaptainApplied(string domain, string leadership, string anchor, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        covenantCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    function applyCaptain(string memory domain, string memory leadership, string memory anchor) public onlyChief {
        captains.push(Captain(domain, leadership, anchor, block.timestamp));
        covenantCount++;
        emit CaptainApplied(domain, leadership, anchor, block.timestamp);
    }

    function getCaptain(uint256 index) public view returns (
        string memory, string memory, string memory, uint256
    ) {
        require(index < captains.length, "Invalid captain index");
        Captain memory c = captains[index];
        return (c.domain, c.leadership, c.anchor, c.timestamp);
    }
}

// SPDX-License-Identifier: MIT
// Contract Name: InterlinkGovernanceRelay
// Purpose: Connect and synchronize outputs of multiple covenants
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

contract InterlinkGovernanceRelay {
    address public chiefOperator;
    uint256 public relayCount;

    struct Relay {
        string sourceCovenant;
        string targetCovenant;
        string linkagePrinciple;
        uint256 timestamp;
    }

    Relay[] public relays;

    event RelayAdded(string sourceCovenant, string targetCovenant, string linkagePrinciple, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        relayCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    // Add new governance relay
    function addRelay(string memory sourceCovenant, string memory targetCovenant, string memory linkagePrinciple) public onlyChief {
        relays.push(Relay(sourceCovenant, targetCovenant, linkagePrinciple, block.timestamp));
        relayCount++;
        emit RelayAdded(sourceCovenant, targetCovenant, linkagePrinciple, block.timestamp);
    }

    // View relay details
    function getRelay(uint256 index) public view returns (string memory, string memory, string memory, uint256) {
        require(index < relays.length, "Invalid relay index");
        Relay memory r = relays[index];
        return (r.sourceCovenant, r.targetCovenant, r.linkagePrinciple, r.timestamp);
    }
}

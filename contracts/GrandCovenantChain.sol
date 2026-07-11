// SPDX-License-Identifier: MIT
// Contract Name: GrandCovenantChain
// Purpose: Master contract linking all modular covenants into one governance chain
// Author: Vin (Chief Operator)

pragma solidity ^0.8.20;

// Import modular covenants
import "./CommunicationCovenant.sol";
import "./PayFairnessCovenant.sol";
import "./RippleIntelligenceCovenant.sol";
import "./EmployeeDevelopmentCovenant.sol";
import "./TransparencyCovenant.sol";
import "./UnityCovenant.sol";
import "./BenefitsCovenant.sol";
import "./RetentionCovenant.sol";
import "./LeadershipRenewalCovenant.sol";

contract GrandCovenantChain {
    address public chiefOperator;
    uint256 public chainCount;

    struct ChainEntry {
        string covenantName;
        string safeguard;
        string anchor;
        string trigger;
        uint256 timestamp;
    }

    ChainEntry[] public chainEntries;

    event ChainLinked(string covenantName, string safeguard, string anchor, string trigger, uint256 timestamp);

    constructor() {
        chiefOperator = msg.sender;
        chainCount = 0;
    }

    modifier onlyChief() {
        require(msg.sender == chiefOperator, "Access restricted to Chief Operator");
        _;
    }

    function linkCovenant(string memory covenantName, string memory safeguard, string memory anchor, string memory trigger) public onlyChief {
        chainEntries.push(ChainEntry(covenantName, safeguard, anchor, trigger, block.timestamp));
        chainCount++;
        emit ChainLinked(covenantName, safeguard, anchor, trigger, block.timestamp);
    }

    function getChainEntry(uint256 index) public view returns (
        string memory, string memory, string memory, string memory, uint256
    ) {
        require(index < chainEntries.length, "Invalid chain index");
        ChainEntry memory ce = chainEntries[index];
        return (ce.covenantName, ce.safeguard, ce.anchor, ce.trigger, ce.timestamp);
    }
}

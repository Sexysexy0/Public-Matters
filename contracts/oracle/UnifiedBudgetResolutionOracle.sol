// SPDX-License-Identifier: UnifiedBudgetResolution-License
pragma solidity ^0.8.0;

contract UnifiedBudgetResolutionOracle {
    address public steward;

    struct ResolutionPulse {
        string chamber;
        string resolutionID;
        string clauseType;
        bool reconciliationTriggered;
        uint256 timestamp;
    }

    ResolutionPulse[] public pulses;

    event ResolutionPulseEmitted(string chamber, string resolutionID, string clauseType, bool triggered, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitPulse(string memory chamber, string memory resolutionID, string memory clauseType, bool reconciliationTriggered) public {
        require(msg.sender == steward, "Only steward can emit");
        pulses.push(ResolutionPulse(chamber, resolutionID, clauseType, reconciliationTriggered, block.timestamp));
        emit ResolutionPulseEmitted(chamber, resolutionID, clauseType, reconciliationTriggered, block.timestamp);
    }

    function getPulse(uint index) public view returns (string memory, string memory, string memory, bool, uint256) {
        ResolutionPulse memory p = pulses[index];
        return (p.chamber, p.resolutionID, p.clauseType, p.reconciliationTriggered, p.timestamp);
    }
}

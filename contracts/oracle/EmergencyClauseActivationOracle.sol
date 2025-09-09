// SPDX-License-Identifier: EmergencyClauseActivation-License
pragma solidity ^0.8.0;

contract EmergencyClauseActivationOracle {
    address public steward;

    struct EmergencySignal {
        string clauseID;
        string originSanctum;
        bool clauseActivated;
        string breachType;
        uint256 timestamp;
    }

    EmergencySignal[] public signals;

    event EmergencyEmitted(string clauseID, string originSanctum, bool clauseActivated, string breachType, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitEmergency(string memory clauseID, string memory originSanctum, bool clauseActivated, string memory breachType) public {
        require(msg.sender == steward, "Only steward can emit");
        signals.push(EmergencySignal(clauseID, originSanctum, clauseActivated, breachType, block.timestamp));
        emit EmergencyEmitted(clauseID, originSanctum, clauseActivated, breachType, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        EmergencySignal memory s = signals[index];
        return (s.clauseID, s.originSanctum, s.clauseActivated, s.breachType, s.timestamp);
    }
}

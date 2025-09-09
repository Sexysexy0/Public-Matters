// SPDX-License-Identifier: MacroVolatilityTelemetry-License
pragma solidity ^0.8.0;

contract MacroVolatilityTelemetryOracle {
    address public steward;

    struct VolatilityPulse {
        string signalType;
        string originEntity;
        bool clauseTriggered;
        uint256 indexValue;
        uint256 timestamp;
    }

    VolatilityPulse[] public pulses;

    event VolatilityEmitted(string signalType, string originEntity, bool clauseTriggered, uint256 indexValue, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitVolatility(string memory signalType, string memory originEntity, bool clauseTriggered, uint256 indexValue) public {
        require(msg.sender == steward, "Only steward can emit");
        pulses.push(VolatilityPulse(signalType, originEntity, clauseTriggered, indexValue, block.timestamp));
        emit VolatilityEmitted(signalType, originEntity, clauseTriggered, indexValue, block.timestamp);
    }

    function getPulse(uint index) public view returns (string memory, string memory, bool, uint256, uint256) {
        VolatilityPulse memory p = pulses[index];
        return (p.signalType, p.originEntity, p.clauseTriggered, p.indexValue, p.timestamp);
    }
}

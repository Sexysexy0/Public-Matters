// SPDX-License-Identifier: AssetDominanceTelemetry-License
pragma solidity ^0.8.0;

contract AssetDominanceTelemetryOracle {
    address public steward;

    struct DominancePulse {
        string asset;
        uint256 dominancePercent;
        bool clauseTriggered;
        string signalType;
        uint256 timestamp;
    }

    DominancePulse[] public pulses;

    event DominanceEmitted(string asset, uint256 dominancePercent, bool clauseTriggered, string signalType, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitDominance(string memory asset, uint256 dominancePercent, bool clauseTriggered, string memory signalType) public {
        require(msg.sender == steward, "Only steward can emit");
        pulses.push(DominancePulse(asset, dominancePercent, clauseTriggered, signalType, block.timestamp));
        emit DominanceEmitted(asset, dominancePercent, clauseTriggered, signalType, block.timestamp);
    }

    function getPulse(uint index) public view returns (string memory, uint256, bool, string memory, uint256) {
        DominancePulse memory p = pulses[index];
        return (p.asset, p.dominancePercent, p.clauseTriggered, p.signalType, p.timestamp);
    }
}

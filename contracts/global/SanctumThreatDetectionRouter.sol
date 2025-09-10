// SPDX-License-Identifier: SanctumThreatDetection-License
pragma solidity ^0.8.0;

contract SanctumThreatDetectionRouter {
    address public steward;

    struct ThreatSignal {
        string originNation;
        string productType;
        string threatLevel;
        bool treatyAligned;
        bool firewallCleared;
        uint256 timestamp;
    }

    ThreatSignal[] public signals;

    event ThreatDetected(string originNation, string productType, string threatLevel, bool treatyAligned, bool firewallCleared, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function detectThreat(string memory originNation, string memory productType, string memory threatLevel, bool treatyAligned, bool firewallCleared) public {
        require(msg.sender == steward, "Only steward can detect");
        signals.push(ThreatSignal(originNation, productType, threatLevel, treatyAligned, firewallCleared, block.timestamp));
        emit ThreatDetected(originNation, productType, threatLevel, treatyAligned, firewallCleared, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, string memory, bool, bool, uint256) {
        ThreatSignal memory s = signals[index];
        return (s.originNation, s.productType, s.threatLevel, s.treatyAligned, s.firewallCleared, s.timestamp);
    }
}

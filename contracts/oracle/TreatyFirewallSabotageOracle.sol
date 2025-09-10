// SPDX-License-Identifier: TreatyFirewallSabotage-License
pragma solidity ^0.8.0;

contract TreatyFirewallSabotageOracle {
    address public steward;

    struct SabotageSignal {
        string treatyName;
        string FXPair;
        bool sabotageConfirmed;
        string firewallStatus;
        uint256 timestamp;
    }

    SabotageSignal[] public signals;

    event TreatySabotageDetected(string treatyName, string FXPair, bool sabotageConfirmed, string firewallStatus, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function detectSabotage(string memory treatyName, string memory FXPair, bool sabotageConfirmed, string memory firewallStatus) public {
        require(msg.sender == steward, "Only steward can detect");
        signals.push(SabotageSignal(treatyName, FXPair, sabotageConfirmed, firewallStatus, block.timestamp));
        emit TreatySabotageDetected(treatyName, FXPair, sabotageConfirmed, firewallStatus, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        SabotageSignal memory s = signals[index];
        return (s.treatyName, s.FXPair, s.sabotageConfirmed, s.firewallStatus, s.timestamp);
    }
}

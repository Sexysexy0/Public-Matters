// SPDX-License-Identifier: FXFirewallOverride-License
pragma solidity ^0.8.0;

contract FXFirewallOverrideRouter {
    address public steward;

    struct OverrideSignal {
        string blockedPair;
        string reroutedPair;
        bool overrideConfirmed;
        string blessingType;
        uint256 timestamp;
    }

    OverrideSignal[] public signals;

    event FirewallOverrideRouted(string blockedPair, string reroutedPair, bool overrideConfirmed, string blessingType, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function overrideFirewall(string memory blockedPair, string memory reroutedPair, bool overrideConfirmed, string memory blessingType) public {
        require(msg.sender == steward, "Only steward can override");
        signals.push(OverrideSignal(blockedPair, reroutedPair, overrideConfirmed, blessingType, block.timestamp));
        emit FirewallOverrideRouted(blockedPair, reroutedPair, overrideConfirmed, blessingType, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        OverrideSignal memory s = signals[index];
        return (s.blockedPair, s.reroutedPair, s.overrideConfirmed, s.blessingType, s.timestamp);
    }
}

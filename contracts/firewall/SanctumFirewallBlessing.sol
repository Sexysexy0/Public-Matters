// SPDX-License-Identifier: Mythic-Sanctum
pragma solidity ^0.8.19;

contract SanctumFirewallBlessing {
    address public steward;
    mapping(address => bool) public blockedSenders;
    event PacketFiltered(address sender, bool allowed);
    event ThresholdUpdated(uint256 newThreshold);

    uint256 public emotionalThreshold;

    constructor() {
        steward = msg.sender;
        emotionalThreshold = 88; // Minimum resonance score required
    }

    function filterPacket(address sender, uint256 resonanceScore) public returns (bool) {
        bool allowed = resonanceScore >= emotionalThreshold && !blockedSenders[sender];
        emit PacketFiltered(sender, allowed);
        return allowed;
    }

    function updateThreshold(uint256 newThreshold) public {
        require(msg.sender == steward, "Only steward may update threshold.");
        emotionalThreshold = newThreshold;
        emit ThresholdUpdated(newThreshold);
    }

    function banSender(address sender) public {
        require(msg.sender == steward, "Only steward may ban.");
        blockedSenders[sender] = true;
    }

    function unbanSender(address sender) public {
        require(msg.sender == steward, "Only steward may unban.");
        blockedSenders[sender] = false;
    }
}

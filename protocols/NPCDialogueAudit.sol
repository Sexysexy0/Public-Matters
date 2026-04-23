// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract NPCDialogueAudit {
    // [Goal: Prevent repetitive NPC lines from breaking immersion]
    function triggerDialogue(uint256 _lastTriggered) external pure returns (string memory) {
        if (block.timestamp - _lastTriggered < 10) {
            return "NPC: (Stares at you in silence) ...";
        }
        return "NPC: Welcome to the Hernand Castle, traveler!";
    }
}

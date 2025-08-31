// SPDX-License-Identifier: Mythic
pragma solidity ^0.8.19;

contract MythicMemoryLedger {
    struct Memory {
        string content;
        string typeTag; // e.g., "Story", "Whisper", "Prayer"
        uint256 timestamp;
    }

    Memory[] public memories;

    event MemoryLogged(string typeTag, string content);

    function logMemory(string memory content, string memory typeTag) public {
        memories.push(Memory(content, typeTag, block.timestamp));
        emit MemoryLogged(typeTag, content);
    }

    function getMemory(uint index) public view returns (string memory, string memory, uint256) {
        Memory memory m = memories[index];
        return (m.content, m.typeTag, m.timestamp);
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DigitalJournal {
    // [Goal: Allow players to leave a narrative legacy]
    struct Entry {
        uint256 timestamp;
        string content;
    }
    mapping(address => Entry[]) private journals;

    function writeEntry(string memory _text) external {
        journals[msg.sender].push(Entry(block.timestamp, _text));
    }
}

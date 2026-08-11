// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract CommunityMatchmaking {
    struct GameMode {
        string modeName;
        bool isEnabled;
        uint256 voteCount;
    }

    mapping(string => GameMode) public modes;
    mapping(address => bool) public hasVoted;
    string[] public allModes;

    event ModeVoted(string modeName, uint256 newVoteCount);
    event ModeRestored(string modeName);

    function voteForMode(string memory modeName) external {
        require(!hasVoted[msg.sender], "Already voted");
        
        // I-check kung bago pa lang itong mode na ito
        if (bytes(modes[modeName].modeName).length == 0 && modes[modeName].voteCount == 0) {
            allModes.push(modeName);
            modes[modeName].modeName = modeName;
        }
        
        modes[modeName].voteCount += 1;
        hasVoted[msg.sender] = true;
        
        emit ModeVoted(modeName, modes[modeName].voteCount);
    }

    function restoreMode(string memory modeName) external {
        require(modes[modeName].voteCount > 100, "Not enough community support");
        modes[modeName].isEnabled = true;
        emit ModeRestored(modeName);
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract RawVoiceVault {
    struct Feedback {
        string rawInput;
        uint256 timestamp;
    }
    
    mapping(address => Feedback) public stakeholderVoices;

    // [Goal: Let the 'Native Language' of data speak without narrative overlays]
    function logRawFeedback(string calldata _rawInput) external {
        stakeholderVoices[msg.sender] = Feedback(_rawInput, block.timestamp);
    }
}

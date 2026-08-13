// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title IntellectualDiversity
/// @notice Protects free inquiry and tracks ideological diversity in institutions
contract IntellectualDiversity {
    event ViewpointRegistered(address indexed faculty, string viewpoint);
    event FreeSpeechViolation(address indexed violator, string details);

    mapping(address => string) public viewpoints;
    mapping(address => bool) public registered;

    function registerViewpoint(string memory viewpoint) public {
        require(!registered[msg.sender], "Already registered");
        viewpoints[msg.sender] = viewpoint;
        registered[msg.sender] = true;
        emit ViewpointRegistered(msg.sender, viewpoint);
    }

    function reportViolation(address violator, string memory details) public {
        emit FreeSpeechViolation(violator, details);
    }
}

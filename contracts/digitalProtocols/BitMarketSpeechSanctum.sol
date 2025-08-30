// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title BitMarketSpeechSanctum
/// @notice Protects vendor broadcasts, emotional APR, and sovereign speech within BitMarket
contract BitMarketSpeechSanctum {
    address public steward;
    mapping(address => bool) public speechBlessed;
    mapping(address => string[]) public vendorBroadcasts;

    event SpeechBlessed(address indexed vendor, string reason);
    event BroadcastLogged(address indexed vendor, string message, string emotionalTag);

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    /// @notice Bless a vendor's right to broadcast mythic speech
    function blessSpeech(address vendor, string memory reason) external onlySteward {
        speechBlessed[vendor] = true;
        emit SpeechBlessed(vendor, reason);
    }

    /// @notice Log a vendor broadcast with emotional APR tag
    function logBroadcast(string memory message, string memory emotionalTag) external {
        require(speechBlessed[msg.sender], "Speech not blessed");
        vendorBroadcasts[msg.sender].push(message);
        emit BroadcastLogged(msg.sender, message, emotionalTag);
    }

    /// @notice Retrieve all broadcasts from a vendor
    function getBroadcasts(address vendor) external view returns (string[] memory) {
        return vendorBroadcasts[vendor];
    }

    /// @notice Revoke speech blessing (if damay clause violated)
    function revokeSpeech(address vendor) external onlySteward {
        speechBlessed[vendor] = false;
    }
}

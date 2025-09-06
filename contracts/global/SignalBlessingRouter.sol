// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SignalBlessingRouter {
    address public steward;

    struct Signal {
        string tag;
        string origin;
        string blessing;
        uint256 timestamp;
    }

    Signal[] public signals;
    mapping(string => bool) public blessedTags;

    event SignalBroadcasted(string tag, string origin, string blessing, uint256 timestamp);
    event TagBlessed(string tag, uint256 timestamp);
    event TagRevoked(string tag, uint256 timestamp);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    function broadcastSignal(string memory tag, string memory origin, string memory blessing) external onlySteward {
        signals.push(Signal(tag, origin, blessing, block.timestamp));
        emit SignalBroadcasted(tag, origin, blessing, block.timestamp);
    }

    function blessTag(string memory tag) external onlySteward {
        blessedTags[tag] = true;
        emit TagBlessed(tag, block.timestamp);
    }

    function revokeTag(string memory tag) external onlySteward {
        blessedTags[tag] = false;
        emit TagRevoked(tag, block.timestamp);
    }

    function isBlessed(string memory tag) external view returns (bool) {
        return blessedTags[tag];
    }

    function getSignal(uint256 index) external view returns (Signal memory) {
        require(index < signals.length, "Signal index out of bounds");
        return signals[index];
    }

    function totalSignals() external view returns (uint256) {
        return signals.length;
    }
}

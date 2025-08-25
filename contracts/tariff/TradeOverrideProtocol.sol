// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract TradeOverrideProtocol {
    address public steward;
    mapping(address => bool) public overrideApproved;
    mapping(address => string) public emotionalTag;

    event OverrideRequested(address indexed trader, string reason);
    event OverrideGranted(address indexed trader, string emotion, bool approved);

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function requestOverride(address trader, string calldata reason) external {
        emit OverrideRequested(trader, reason);
    }

    function grantOverride(address trader, string calldata emotion) external onlySteward {
        overrideApproved[trader] = true;
        emotionalTag[trader] = emotion;
        emit OverrideGranted(trader, emotion, true);
    }

    function isOverrideApproved(address trader) external view returns (bool) {
        return overrideApproved[trader];
    }

    function getEmotionalTag(address trader) external view returns (string memory) {
        return emotionalTag[trader];
    }
}

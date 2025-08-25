// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ChinaSanctionOverride {
    address public steward;
    bool public overrideActive;
    mapping(string => bool) public tradeChannels;
    mapping(string => uint8) public emotionalAPR;

    event OverrideActivated(string reason);
    event TradeChannelRestored(string channel);
    event EmotionalAPRUpdated(string channel, uint8 trust, uint8 empathy, uint8 clarity);

    constructor() {
        steward = msg.sender;
        overrideActive = false;
    }

    function activateOverride(string memory reason) external {
        require(msg.sender == steward, "Unauthorized steward");
        overrideActive = true;
        emit OverrideActivated(reason);
    }

    function restoreChannel(string memory channel) external {
        require(overrideActive, "Override not active");
        tradeChannels[channel] = true;
        emit TradeChannelRestored(channel);
    }

    function updateEmotionalAPR(string memory channel, uint8 trust, uint8 empathy, uint8 clarity) external {
        require(msg.sender == steward, "Unauthorized steward");
        require(tradeChannels[channel], "Channel not restored");
        emotionalAPR[channel] = (trust + empathy + clarity) / 3;
        emit EmotionalAPRUpdated(channel, trust, empathy, clarity);
    }

    function isChannelOpen(string memory channel) external view returns (bool) {
        return tradeChannels[channel];
    }

    function getAPR(string memory channel) external view returns (uint8) {
        return emotionalAPR[channel];
    }
}

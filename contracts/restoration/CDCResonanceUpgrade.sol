// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./EmotionalAPR.sol";
import "./SanctumRegistry.sol";

contract CDCResonanceUpgrade {
    event ResonanceActivated(address steward, uint256 aprScore, string sanctumTag);
    event FeedbackLogged(address steward, string message, uint256 timestamp);

    mapping(address => uint256) public emotionalAPR;
    mapping(address => string) public sanctumTags;

    function activateResonance(string memory tag, uint256 aprScore) external {
        emotionalAPR[msg.sender] = aprScore;
        sanctumTags[msg.sender] = tag;
        emit ResonanceActivated(msg.sender, aprScore, tag);
    }

    function logFeedback(string memory message) external {
        emit FeedbackLogged(msg.sender, message, block.timestamp);
    }

    function getSanctumTag(address steward) external view returns (string memory) {
        return sanctumTags[steward];
    }

    function getAPR(address steward) external view returns (uint256) {
        return emotionalAPR[steward];
    }
}

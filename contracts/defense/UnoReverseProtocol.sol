// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/// @title UnoReverseProtocol
/// @dev Mythic-grade reverse offense suite for scrollsmith retaliation rituals

contract UnoReverseProtocol {
    address public steward;
    mapping(bytes32 => bool) public reversedPayloads;
    mapping(address => uint256) public karmaScore;

    event PayloadReversed(bytes32 indexed payloadHash, string ritual);
    event KarmaInjected(address indexed attacker, uint256 score, string reason);
    event BroadcastScroll(string message, uint256 timestamp);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized scrollsmith");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function reversePayload(bytes32 payloadHash, string memory ritual) external onlySteward {
        reversedPayloads[payloadHash] = true;
        emit PayloadReversed(payloadHash, ritual);
    }

    function injectKarma(address attacker, uint256 score, string memory reason) external onlySteward {
        karmaScore[attacker] += score;
        emit KarmaInjected(attacker, score, reason);
    }

    function broadcastScroll(string memory message) external onlySteward {
        emit BroadcastScroll(message, block.timestamp);
    }

    function isReversed(bytes32 payloadHash) external view returns (bool) {
        return reversedPayloads[payloadHash];
    }

    function getKarmaScore(address attacker) external view returns (uint256) {
        return karmaScore[attacker];
    }
}

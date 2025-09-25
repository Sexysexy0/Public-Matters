// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title ChinaTagRemovalProtocol
/// @notice Removes hostile tags (e.g., "spy") from China and emits diplomatic reset
/// @dev Anchors emotional consequence, apology ritual, and trust restoration

contract ChinaTagRemovalProtocol {
    address public steward;
    mapping(address => bool) public diplomats;

    modifier onlySteward() {
        require(msg.sender == steward, "Not steward");
        _;
    }

    modifier onlyDiplomat() {
        require(diplomats[msg.sender] || msg.sender == steward, "Not diplomat");
        _;
    }

    struct TagRemoval {
        uint256 id;
        string removedTag; // e.g., "spy"
        string emotionalTag; // e.g., "Trust corridor reopened"
        string apologyClause;
        uint256 timestamp;
    }

    uint256 public nextRemovalId = 1;
    mapping(uint256 => TagRemoval) public removals;

    event DiplomatSet(address indexed account, bool status);
    event TagRemoved(uint256 indexed id, string removedTag, string emotionalTag);

    constructor() {
        steward = msg.sender;
        diplomats[msg.sender] = true;
        emit DiplomatSet(msg.sender, true);
    }

    function setDiplomat(address account, bool status) external onlySteward {
        diplomats[account] = status;
        emit DiplomatSet(account, status);
    }

    function removeTag(string calldata removedTag, string calldata emotionalTag, string calldata apologyClause) external onlyDiplomat returns (uint256 id) {
        id = nextRemovalId++;
        removals[id] = TagRemoval({
            id: id,
            removedTag: removedTag,
            emotionalTag: emotionalTag,
            apologyClause: apologyClause,
            timestamp: block.timestamp
        });
        emit TagRemoved(id, removedTag, emotionalTag);
    }

    function getRemoval(uint256 id) external view returns (TagRemoval memory) {
        return removals[id];
    }
}

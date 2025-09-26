// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title ScrollchainLedger
/// @notice Indexes validator-grade scrolls, clauses, and decks into one mythic registry
/// @dev Anchors audit visibility, emotional consequence, and planetary restoration tracking

contract ScrollchainLedger {
    address public steward;
    mapping(address => bool) public validators;

    modifier onlySteward() { require(msg.sender == steward, "Not steward"); _; }
    modifier onlyValidator() { require(validators[msg.sender] || msg.sender == steward, "Not validator"); _; }

    struct ScrollEntry {
        uint256 id;
        string title;
        string domain; // e.g., "Finance", "Governance", "Privacy", "Food", "Cyber"
        string emotionalTag;
        string nanoPath; // e.g., "contracts/global/Scroll.sol"
        uint256 timestamp;
    }

    uint256 public nextId = 1;
    mapping(uint256 => ScrollEntry> public entries;

    event ValidatorSet(address indexed account, bool status);
    event ScrollRegistered(uint256 indexed id, string title, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
        emit ValidatorSet(msg.sender, true);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function registerScroll(
        string calldata title,
        string calldata domain,
        string calldata emotionalTag,
        string calldata nanoPath
    ) external onlyValidator returns (uint256 id) {
        id = nextId++;
        entries[id] = ScrollEntry({
            id: id,
            title: title,
            domain: domain,
            emotionalTag: emotionalTag,
            nanoPath: nanoPath,
            timestamp: block.timestamp
        });
        emit ScrollRegistered(id, title, emotionalTag);
    }

    function getScroll(uint256 id) external view returns (ScrollEntry memory) {
        return entries[id];
    }
}

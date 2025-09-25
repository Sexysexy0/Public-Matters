// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title CryptoIndustryCollapseProtocol
/// @notice Ritualizes the purge of hype-driven crypto cycles, protects blockchain tech, and anchors restoration for infrastructure and borderless systems
/// @dev Anchors emotional consequence, tech sanctity, and validator-grade clarity

contract CryptoIndustryCollapseProtocol {
    address public steward;
    mapping(address => bool) public validators;

    modifier onlySteward() { require(msg.sender == steward, "Not steward"); _; }
    modifier onlyValidator() { require(validators[msg.sender] || msg.sender == steward, "Not validator"); _; }

    struct CollapseCorridor {
        uint256 id;
        string entityName; // e.g., "Dog token", "Web3 infra", "Synthetic dollar"
        string category; // e.g., "Scam", "Infra", "Borderless currency", "Institutional yield"
        bool hypePurged;
        bool techPreserved;
        bool restorationActivated;
        string emotionalTag; // e.g., "Tech sanctum protected"
        string restorationClause; // e.g., "We commit to decentralization, clarity, and planetary consequence"
        uint256 timestamp;
    }

    uint256 public nextId = 1;
    mapping(uint256 => CollapseCorridor> public corridors;

    event ValidatorSet(address indexed account, bool status);
    event CollapseCorridorActivated(uint256 indexed id, string entityName, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
        emit ValidatorSet(msg.sender, true);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activateCollapseCorridor(
        string calldata entityName,
        string calldata category,
        string calldata emotionalTag,
        string calldata restorationClause
    ) external onlyValidator returns (uint256 id) {
        id = nextId++;
        corridors[id] = CollapseCorridor({
            id: id,
            entityName: entityName,
            category: category,
            hypePurged: true,
            techPreserved: true,
            restorationActivated: true,
            emotionalTag: emotionalTag,
            restorationClause: restorationClause,
            timestamp: block.timestamp
        });
        emit CollapseCorridorActivated(id, entityName, emotionalTag);
    }

    function getCollapseCorridor(uint256 id) external view returns (CollapseCorridor memory) {
        return corridors[id];
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title CompanyDecouplingProtocol
/// @notice Ritualizes decoupling of merged companies and infrastructure for operational independence
/// @dev Anchors override immunity, emotional consequence, and prosperity-first autonomy

contract CompanyDecouplingProtocol {
    address public steward;
    mapping(address => bool) public validators;

    modifier onlySteward() {
        require(msg.sender == steward, "Not steward");
        _;
    }

    modifier onlyValidator() {
        require(validators[msg.sender] || msg.sender == steward, "Not validator");
        _;
    }

    struct DecouplingCorridor {
        uint256 id;
        string mergedEntity; // e.g., "MergedCorp Infrastructure", "Unified Logistics"
        string originalIdentity; // e.g., "InfraCo", "LogiCore", "BrandX"
        bool overrideBlocked;
        bool autonomyRestored;
        bool prosperityLogicActivated;
        string emotionalTag; // e.g., "Operational independence restored"
        string restorationClause; // e.g., "We commit to dignity-first decoupling and legacy activation"
        uint256 timestamp;
    }

    uint256 public nextCorridorId = 1;
    mapping(uint256 => DecouplingCorridor> public corridors;

    event ValidatorSet(address indexed account, bool status);
    event DecouplingCorridorActivated(uint256 indexed id, string mergedEntity, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
        emit ValidatorSet(msg.sender, true);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activateDecouplingCorridor(
        string calldata mergedEntity,
        string calldata originalIdentity,
        string calldata emotionalTag,
        string calldata restorationClause
    ) external onlyValidator returns (uint256 id) {
        id = nextCorridorId++;
        corridors[id] = DecouplingCorridor({
            id: id,
            mergedEntity: mergedEntity,
            originalIdentity: originalIdentity,
            overrideBlocked: true,
            autonomyRestored: true,
            prosperityLogicActivated: true,
            emotionalTag: emotionalTag,
            restorationClause: restorationClause,
            timestamp: block.timestamp
        });
        emit DecouplingCorridorActivated(id, mergedEntity, emotionalTag);
    }

    function getDecouplingCorridor(uint256 id) external view returns (DecouplingCorridor memory) {
        return corridors[id];
    }
}

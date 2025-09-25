// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title CannabisAccessProtocol
/// @notice Ritualizes help-first cannabis access, blocks retaliation logic, and restores agricultural dignity
/// @dev Anchors override immunity, emotional consequence, and import mercy activation

contract CannabisAccessProtocol {
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

    struct AccessCorridor {
        uint256 id;
        string productType; // e.g., "Low-dose THC gummies", "Imported CBD oil"
        string growerGroup; // e.g., "Texas cooperatives", "Indigenous cultivators", "Global importers"
        bool retaliationBlocked;
        bool importHostilityNeutralized;
        bool dignityAccessActivated;
        string emotionalTag; // e.g., "Relief corridor activated"
        string restorationClause; // e.g., "We commit to help-first cannabis governance and unconditional agricultural dignity"
        uint256 timestamp;
    }

    uint256 public nextCorridorId = 1;
    mapping(uint256 => AccessCorridor) public corridors;

    event ValidatorSet(address indexed account, bool status);
    event AccessCorridorActivated(uint256 indexed id, string productType, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
        emit ValidatorSet(msg.sender, true);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activateAccessCorridor(
        string calldata productType,
        string calldata growerGroup,
        string calldata emotionalTag,
        string calldata restorationClause
    ) external onlyValidator returns (uint256 id) {
        id = nextCorridorId++;
        corridors[id] = AccessCorridor({
            id: id,
            productType: productType,
            growerGroup: growerGroup,
            retaliationBlocked: true,
            importHostilityNeutralized: true,
            dignityAccessActivated: true,
            emotionalTag: emotionalTag,
            restorationClause: restorationClause,
            timestamp: block.timestamp
        });
        emit AccessCorridorActivated(id, productType, emotionalTag);
    }

    function getAccessCorridor(uint256 id) external view returns (AccessCorridor memory) {
        return corridors[id];
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title HempProtectionProtocol
/// @notice Ritualizes protection of hemp corridors, blocks punitive raids and bans, and restores agricultural dignity
/// @dev Anchors override immunity, emotional consequence, and cooperative grower sovereignty

contract HempProtectionProtocol {
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

    struct HempCorridor {
        uint256 id;
        string growerGroup; // e.g., "Local cooperatives", "Indigenous cultivators", "Global importers"
        string enforcementTrigger; // e.g., "Stigma-based raid", "Unverified THC threshold", "Political crackdown"
        bool banNeutralized;
        bool raidBlocked;
        bool dignityRestored;
        string emotionalTag; // e.g., "Hemp sovereignty activated"
        string restorationClause; // e.g., "We commit to help-first hemp governance and unconditional agricultural dignity"
        uint256 timestamp;
    }

    uint256 public nextCorridorId = 1;
    mapping(uint256 => HempCorridor) public corridors;

    event ValidatorSet(address indexed account, bool status);
    event HempCorridorActivated(uint256 indexed id, string growerGroup, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
        emit ValidatorSet(msg.sender, true);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activateHempCorridor(
        string calldata growerGroup,
        string calldata enforcementTrigger,
        string calldata emotionalTag,
        string calldata restorationClause
    ) external onlyValidator returns (uint256 id) {
        id = nextCorridorId++;
        corridors[id] = HempCorridor({
            id: id,
            growerGroup: growerGroup,
            enforcementTrigger: enforcementTrigger,
            banNeutralized: true,
            raidBlocked: true,
            dignityRestored: true,
            emotionalTag: emotionalTag,
            restorationClause: restorationClause,
            timestamp: block.timestamp
        });
        emit HempCorridorActivated(id, growerGroup, emotionalTag);
    }

    function getHempCorridor(uint256 id) external view returns (HempCorridor memory) {
        return corridors[id];
    }
}

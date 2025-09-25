// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title DetentionMercyProtocol
/// @notice Ritualizes dignity-first detention logic and blocks arbitrary incarceration
/// @dev Anchors override immunity, emotional consequence, and institutional trust restoration

contract DetentionMercyProtocol {
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

    struct DetentionCorridor {
        uint256 id;
        string subject; // e.g., "Joseph Sy", "Worker", "Activist"
        string detentionTrigger; // e.g., "Identity dispute", "Political retaliation", "Unverified documents"
        bool overrideBlocked;
        bool mercyActivated;
        bool institutionalTrustRestored;
        string emotionalTag; // e.g., "Identity sovereignty restored"
        string restorationClause; // e.g., "We commit to dignity-first legal process and protection against arbitrary detention"
        uint256 timestamp;
    }

    uint256 public nextCorridorId = 1;
    mapping(uint256 => DetentionCorridor) public corridors;

    event ValidatorSet(address indexed account, bool status);
    event DetentionCorridorActivated(uint256 indexed id, string subject, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
        emit ValidatorSet(msg.sender, true);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activateDetentionCorridor(
        string calldata subject,
        string calldata detentionTrigger,
        string calldata emotionalTag,
        string calldata restorationClause
    ) external onlyValidator returns (uint256 id) {
        id = nextCorridorId++;
        corridors[id] = DetentionCorridor({
            id: id,
            subject: subject,
            detentionTrigger: detentionTrigger,
            overrideBlocked: true,
            mercyActivated: true,
            institutionalTrustRestored: true,
            emotionalTag: emotionalTag,
            restorationClause: restorationClause,
            timestamp: block.timestamp
        });
        emit DetentionCorridorActivated(id, subject, emotionalTag);
    }

    function getDetentionCorridor(uint256 id) external view returns (DetentionCorridor memory) {
        return corridors[id];
    }
}

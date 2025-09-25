// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title DiplomaticProtectionOverrideProtocol
/// @notice Ritualizes override of punitive restrictions on foreign nationals and diplomats
/// @dev Anchors override immunity, civic access restoration, and emotional consequence mapping

contract DiplomaticProtectionOverrideProtocol {
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

    struct ProtectionCorridor {
        uint256 id;
        string diplomatName;
        string countryOfOrigin;
        string restrictionType; // e.g., "Retail ban", "Movement restriction", "Access denial"
        bool overrideActivated;
        bool civicAccessRestored;
        string emotionalTag; // e.g., "Punitive corridor neutralized"
        string restorationClause; // e.g., "We commit to hospitality and dignity regardless of origin"
        uint256 timestamp;
    }

    uint256 public nextId = 1;
    mapping(uint256 => ProtectionCorridor> public corridors;

    event ValidatorSet(address indexed account, bool status);
    event ProtectionCorridorActivated(uint256 indexed id, string diplomatName, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
        emit ValidatorSet(msg.sender, true);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activateProtectionCorridor(
        string calldata diplomatName,
        string calldata countryOfOrigin,
        string calldata restrictionType,
        string calldata emotionalTag,
        string calldata restorationClause
    ) external onlyValidator returns (uint256 id) {
        id = nextId++;
        corridors[id] = ProtectionCorridor({
            id: id,
            diplomatName: diplomatName,
            countryOfOrigin: countryOfOrigin,
            restrictionType: restrictionType,
            overrideActivated: true,
            civicAccessRestored: true,
            emotionalTag: emotionalTag,
            restorationClause: restorationClause,
            timestamp: block.timestamp
        });
        emit ProtectionCorridorActivated(id, diplomatName, emotionalTag);
    }

    function getProtectionCorridor(uint256 id) external view returns (ProtectionCorridor memory) {
        return corridors[id];
    }
}

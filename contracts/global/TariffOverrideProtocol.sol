// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title TariffOverrideProtocol
/// @notice Ritualizes override of imposed tariffs and anchors fair trade restoration
/// @dev Anchors override immunity, emotional consequence, and diplomatic restoration clause

contract TariffOverrideProtocol {
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

    struct TariffCorridor {
        uint256 id;
        string country; // e.g., "South Korea", "Philippines"
        string imposedBy; // e.g., "United States", "China"
        string affectedSector; // e.g., "Steel", "Semiconductors", "Agriculture"
        bool overrideActivated;
        bool mutualProsperityCommitted;
        string emotionalTag; // e.g., "Trade dignity restored"
        string restorationClause; // e.g., "We commit to tariff-free corridors and economic fairness"
        uint256 timestamp;
    }

    uint256 public nextCorridorId = 1;
    mapping(uint256 => TariffCorridor> public corridors;

    event ValidatorSet(address indexed account, bool status);
    event TariffCorridorActivated(uint256 indexed id, string country, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
        emit ValidatorSet(msg.sender, true);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activateTariffCorridor(
        string calldata country,
        string calldata imposedBy,
        string calldata affectedSector,
        string calldata emotionalTag,
        string calldata restorationClause
    ) external onlyValidator returns (uint256 id) {
        id = nextCorridorId++;
        corridors[id] = TariffCorridor({
            id: id,
            country: country,
            imposedBy: imposedBy,
            affectedSector: affectedSector,
            overrideActivated: true,
            mutualProsperityCommitted: true,
            emotionalTag: emotionalTag,
            restorationClause: restorationClause,
            timestamp: block.timestamp
        });
        emit TariffCorridorActivated(id, country, emotionalTag);
    }

    function getTariffCorridor(uint256 id) external view returns (TariffCorridor memory) {
        return corridors[id];
    }
}

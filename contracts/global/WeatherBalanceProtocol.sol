// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title WeatherBalanceProtocol
/// @notice Ritualizes ethical weather modification and restores planetary climate balance
/// @dev Anchors override immunity, emotional consequence, and sovereign stewardship

contract WeatherBalanceProtocol {
    address public steward;
    mapping(address => bool) public climateGuardians;

    modifier onlySteward() {
        require(msg.sender == steward, "Not steward");
        _;
    }

    modifier onlyGuardian() {
        require(climateGuardians[msg.sender] || msg.sender == steward, "Not guardian");
        _;
    }

    struct ClimateCorridor {
        uint256 id;
        string region; // e.g., "Central Luzon", "Texas", "Global Tropics"
        string modificationType; // e.g., "Cloud seeding", "Rain suppression", "Storm redirection"
        bool overrideBlocked;
        bool balanceActivated;
        string emotionalTag; // e.g., "Planetary harmony restored"
        string restorationClause; // e.g., "We commit to ethical climate stewardship and nonviolent intervention"
        uint256 timestamp;
    }

    uint256 public nextCorridorId = 1;
    mapping(uint256 => ClimateCorridor) public corridors;

    event GuardianSet(address indexed account, bool status);
    event ClimateBalanceActivated(uint256 indexed id, string region, string emotionalTag);

    constructor() {
        steward = msg.sender;
        climateGuardians[msg.sender] = true;
        emit GuardianSet(msg.sender, true);
    }

    function setGuardian(address account, bool status) external onlySteward {
        climateGuardians[account] = status;
        emit GuardianSet(account, status);
    }

    function activateBalance(
        string calldata region,
        string calldata modificationType,
        string calldata emotionalTag,
        string calldata restorationClause
    ) external onlyGuardian returns (uint256 id) {
        id = nextCorridorId++;
        corridors[id] = ClimateCorridor({
            id: id,
            region: region,
            modificationType: modificationType,
            overrideBlocked: true,
            balanceActivated: true,
            emotionalTag: emotionalTag,
            restorationClause: restorationClause,
            timestamp: block.timestamp
        });
        emit ClimateBalanceActivated(id, region, emotionalTag);
    }

    function getClimateCorridor(uint256 id) external view returns (ClimateCorridor memory) {
        return corridors[id];
    }
}

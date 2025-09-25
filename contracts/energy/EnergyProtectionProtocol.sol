// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title EnergyProtectionProtocol
/// @notice Ritualizes protection of domestic energy producers and opens negotiation corridors for trade balance
/// @dev Anchors override removal, emotional consequence, and stakeholder-led resolution

contract EnergyProtectionProtocol {
    address public steward;
    mapping(address => bool) public protectors;

    modifier onlySteward() {
        require(msg.sender == steward, "Not steward");
        _;
    }

    modifier onlyProtector() {
        require(protectors[msg.sender] || msg.sender == steward, "Not protector");
        _;
    }

    struct EnergyCorridor {
        uint256 id;
        string assetClass; // e.g., "Oil", "Solar", "Natural Gas"
        string foreignPressure; // e.g., "Subsidized imports from China"
        bool overrideRemoved;
        bool negotiationActivated;
        string emotionalTag; // e.g., "Energy dignity restored"
        string restorationClause; // e.g., "We commit to fair competition and mutual gain"
        uint256 timestamp;
    }

    uint256 public nextCorridorId = 1;
    mapping(uint256 => EnergyCorridor) public corridors;

    event ProtectorSet(address indexed account, bool status);
    event EnergyCorridorRestored(uint256 indexed id, string assetClass, string emotionalTag);

    constructor() {
        steward = msg.sender;
        protectors[msg.sender] = true;
        emit ProtectorSet(msg.sender, true);
    }

    function setProtector(address account, bool status) external onlySteward {
        protectors[account] = status;
        emit ProtectorSet(account, status);
    }

    function restoreCorridor(
        string calldata assetClass,
        string calldata foreignPressure,
        string calldata emotionalTag,
        string calldata restorationClause
    ) external onlyProtector returns (uint256 id) {
        id = nextCorridorId++;
        corridors[id] = EnergyCorridor({
            id: id,
            assetClass: assetClass,
            foreignPressure: foreignPressure,
            overrideRemoved: true,
            negotiationActivated: true,
            emotionalTag: emotionalTag,
            restorationClause: restorationClause,
            timestamp: block.timestamp
        });
        emit EnergyCorridorRestored(id, assetClass, emotionalTag);
    }

    function getCorridor(uint256 id) external view returns (EnergyCorridor memory) {
        return corridors[id];
    }
}

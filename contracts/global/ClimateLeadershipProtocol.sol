// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title ClimateLeadershipProtocol
/// @notice Ritualizes national climate pledges and anchors planetary stewardship
/// @dev Anchors override immunity, emotional consequence, and restoration clause logic

contract ClimateLeadershipProtocol {
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

    struct ClimateCorridor {
        uint256 id;
        string country;
        string leader;
        string pledgeDetail; // e.g., "Cut emissions by 10% by 2035"
        bool overrideActivated;
        bool denialBlocked;
        bool stewardshipCommitted;
        string emotionalTag; // e.g., "Green transition activated"
        string restorationClause; // e.g., "We commit to planetary care and emissions reduction"
        uint256 timestamp;
    }

    uint256 public nextId = 1;
    mapping(uint256 => ClimateCorridor> public corridors;

    event ValidatorSet(address indexed account, bool status);
    event ClimateCorridorActivated(uint256 indexed id, string country, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
        emit ValidatorSet(msg.sender, true);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activateClimateCorridor(
        string calldata country,
        string calldata leader,
        string calldata pledgeDetail,
        string calldata emotionalTag,
        string calldata restorationClause
    ) external onlyValidator returns (uint256 id) {
        id = nextId++;
        corridors[id] = ClimateCorridor({
            id: id,
            country: country,
            leader: leader,
            pledgeDetail: pledgeDetail,
            overrideActivated: true,
            denialBlocked: true,
            stewardshipCommitted: true,
            emotionalTag: emotionalTag,
            restorationClause: restorationClause,
            timestamp: block.timestamp
        });
        emit ClimateCorridorActivated(id, country, emotionalTag);
    }

    function getClimateCorridor(uint256 id) external view returns (ClimateCorridor memory) {
        return corridors[id];
    }
}

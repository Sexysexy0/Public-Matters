// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title PHChinaResetProtocol
/// @notice Ritualizes diplomatic restoration between the Philippines and China
/// @dev Anchors apology clause, emotional consequence, and treaty-grade reset

contract PHChinaResetProtocol {
    address public steward;
    mapping(address => bool) public envoys;

    modifier onlySteward() {
        require(msg.sender == steward, "Not steward");
        _;
    }

    modifier onlyEnvoy() {
        require(envoys[msg.sender] || msg.sender == steward, "Not envoy");
        _;
    }

    struct ResetEvent {
        uint256 id;
        string corridor; // e.g., "Maritime", "Trade", "Security"
        string emotionalTag;
        string apologyClause;
        uint256 timestamp;
    }

    uint256 public nextEventId = 1;
    mapping(uint256 => ResetEvent) public events;

    event EnvoySet(address indexed account, bool status);
    event ResetLogged(uint256 indexed id, string corridor, string emotionalTag);

    constructor() {
        steward = msg.sender;
        envoys[msg.sender] = true;
        emit EnvoySet(msg.sender, true);
    }

    function setEnvoy(address account, bool status) external onlySteward {
        envoys[account] = status;
        emit EnvoySet(account, status);
    }

    function logReset(
        string calldata corridor,
        string calldata emotionalTag,
        string calldata apologyClause
    ) external onlyEnvoy returns (uint256 id) {
        id = nextEventId++;
        events[id] = ResetEvent({
            id: id,
            corridor: corridor,
            emotionalTag: emotionalTag,
            apologyClause: apologyClause,
            timestamp: block.timestamp
        });
        emit ResetLogged(id, corridor, emotionalTag);
    }

    function getReset(uint256 id) external view returns (ResetEvent memory) {
        return events[id];
    }
}

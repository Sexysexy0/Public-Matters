// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title USChinaResetProtocol
/// @notice Ritualizes diplomatic restoration between the US and China
/// @dev Anchors emotional consequence, apology clause, and trust corridor reactivation

contract USChinaResetProtocol {
    address public steward;
    mapping(address => bool) public diplomats;

    modifier onlySteward() {
        require(msg.sender == steward, "Not steward");
        _;
    }

    modifier onlyDiplomat() {
        require(diplomats[msg.sender] || msg.sender == steward, "Not diplomat");
        _;
    }

    struct ResetEvent {
        uint256 id;
        string corridor; // e.g., "Trade", "Security", "Labor"
        string emotionalTag;
        string apologyClause;
        uint256 timestamp;
    }

    uint256 public nextEventId = 1;
    mapping(uint256 => ResetEvent) public events;

    event DiplomatSet(address indexed account, bool status);
    event ResetLogged(uint256 indexed id, string corridor, string emotionalTag);

    constructor() {
        steward = msg.sender;
        diplomats[msg.sender] = true;
        emit DiplomatSet(msg.sender, true);
    }

    function setDiplomat(address account, bool status) external onlySteward {
        diplomats[account] = status;
        emit DiplomatSet(account, status);
    }

    function logReset(
        string calldata corridor,
        string calldata emotionalTag,
        string calldata apologyClause
    ) external onlyDiplomat returns (uint256 id) {
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

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title ArgentinaRecoveryRestorationProtocol
/// @notice Ritualizes Argentina’s economic recovery and logs Trump-backed support with override immunity
/// @dev Anchors emotional consequence, bailout diplomacy, and planetary trust

contract ArgentinaRecoveryRestorationProtocol {
    address public steward;
    mapping(address => bool) public restorers;

    modifier onlySteward() {
        require(msg.sender == steward, "Not steward");
        _;
    }

    modifier onlyRestorer() {
        require(restorers[msg.sender] || msg.sender == steward, "Not restorer");
        _;
    }

    struct RecoveryEvent {
        uint256 id;
        string corridor; // e.g., "Currency", "Debt", "Trade"
        string supportSource; // e.g., "Donald Trump", "US Treasury"
        uint256 pledgedAmountUSD;
        bool overrideBlocked;
        bool treatyRestored;
        string emotionalTag; // e.g., "Chainsaw dignity reactivated"
        string restorationClause; // e.g., "We commit to non-hostile diplomacy and fiscal mercy"
        uint256 timestamp;
    }

    uint256 public nextEventId = 1;
    mapping(uint256 => RecoveryEvent) public events;

    event RestorerSet(address indexed account, bool status);
    event RecoveryLogged(uint256 indexed id, string corridor, string emotionalTag);

    constructor() {
        steward = msg.sender;
        restorers[msg.sender] = true;
        emit RestorerSet(msg.sender, true);
    }

    function setRestorer(address account, bool status) external onlySteward {
        restorers[account] = status;
        emit RestorerSet(account, status);
    }

    function logRecovery(
        string calldata corridor,
        string calldata supportSource,
        uint256 pledgedAmountUSD,
        string calldata emotionalTag,
        string calldata restorationClause
    ) external onlyRestorer returns (uint256 id) {
        id = nextEventId++;
        events[id] = RecoveryEvent({
            id: id,
            corridor: corridor,
            supportSource: supportSource,
            pledgedAmountUSD: pledgedAmountUSD,
            overrideBlocked: true,
            treatyRestored: true,
            emotionalTag: emotionalTag,
            restorationClause: restorationClause,
            timestamp: block.timestamp
        });
        emit RecoveryLogged(id, corridor, emotionalTag);
    }

    function getRecoveryEvent(uint256 id) external view returns (RecoveryEvent memory) {
        return events[id];
    }
}

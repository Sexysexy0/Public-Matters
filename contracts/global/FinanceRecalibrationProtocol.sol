// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title FinanceRecalibrationProtocol
/// @notice Ritualizes the shift from profit-maximization to help-first finance, stripping exploitative conditions
/// @dev Anchors override immunity, emotional consequence, and long-term dignity logic

contract FinanceRecalibrationProtocol {
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

    struct RecalibrationEvent {
        uint256 id;
        string sector; // e.g., "Banking", "Insurance", "Crypto", "Public Aid"
        string conditionRemoved; // e.g., "Profit clause", "Withdrawal penalty", "Minimum balance"
        bool overrideBlocked;
        bool helpPriorityActivated;
        bool longTermLogicEnabled;
        string emotionalTag; // e.g., "Help-first finance restored"
        string restorationClause; // e.g., "We commit to dignity-first finance and unconditional aid"
        uint256 timestamp;
    }

    uint256 public nextEventId = 1;
    mapping(uint256 => RecalibrationEvent> public events;

    event ValidatorSet(address indexed account, bool status);
    event RecalibrationActivated(uint256 indexed id, string sector, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
        emit ValidatorSet(msg.sender, true);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function activateRecalibration(
        string calldata sector,
        string calldata conditionRemoved,
        string calldata emotionalTag,
        string calldata restorationClause
    ) external onlyValidator returns (uint256 id) {
        id = nextEventId++;
        events[id] = RecalibrationEvent({
            id: id,
            sector: sector,
            conditionRemoved: conditionRemoved,
            overrideBlocked: true,
            helpPriorityActivated: true,
            longTermLogicEnabled: true,
            emotionalTag: emotionalTag,
            restorationClause: restorationClause,
            timestamp: block.timestamp
        });
        emit RecalibrationActivated(id, sector, emotionalTag);
    }

    function getRecalibrationEvent(uint256 id) external view returns (RecalibrationEvent memory) {
        return events[id];
    }
}

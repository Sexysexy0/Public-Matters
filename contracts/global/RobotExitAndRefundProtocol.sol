// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title RobotExitAndRefundProtocol
/// @notice Ritualizes the removal of malfunctioning robots and refunds affected parties with override immunity
/// @dev Anchors emotional consequence, operational dignity, and planetary trust

contract RobotExitAndRefundProtocol {
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

    struct ExitEvent {
        uint256 id;
        string robotModel; // e.g., "TeslaBot V3", "FANUC Arm"
        string breachType; // e.g., "Override failure", "Violent malfunction"
        uint256 refundAmountUSD;
        bool overrideBlocked;
        bool robotRemoved;
        string emotionalTag; // e.g., "Worker dignity restored"
        string restorationClause; // e.g., "We commit to nonviolent automation and full restitution"
        uint256 timestamp;
    }

    uint256 public nextEventId = 1;
    mapping(uint256 => ExitEvent) public events;

    event ValidatorSet(address indexed account, bool status);
    event RobotExitLogged(uint256 indexed id, string robotModel, string emotionalTag);

    constructor() {
        steward = msg.sender;
        validators[msg.sender] = true;
        emit ValidatorSet(msg.sender, true);
    }

    function setValidator(address account, bool status) external onlySteward {
        validators[account] = status;
        emit ValidatorSet(account, status);
    }

    function logRobotExit(
        string calldata robotModel,
        string calldata breachType,
        uint256 refundAmountUSD,
        string calldata emotionalTag,
        string calldata restorationClause
    ) external onlyValidator returns (uint256 id) {
        id = nextEventId++;
        events[id] = ExitEvent({
            id: id,
            robotModel: robotModel,
            breachType: breachType,
            refundAmountUSD: refundAmountUSD,
            overrideBlocked: true,
            robotRemoved: true,
            emotionalTag: emotionalTag,
            restorationClause: restorationClause,
            timestamp: block.timestamp
        });
        emit RobotExitLogged(id, robotModel, emotionalTag);
    }

    function getExitEvent(uint256 id) external view returns (ExitEvent memory) {
        return events[id];
    }
}

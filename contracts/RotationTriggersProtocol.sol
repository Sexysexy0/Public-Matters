pragma solidity ^0.8.20;

contract RotationTriggersProtocol {
    address public admin;

    struct Trigger {
        string condition;    // e.g. gold ↑10%, equities rally, BTC consolidation
        string action;       // e.g. rotate gains to BTC, accumulate, trim
        string source;       // e.g. gold, equities, reserves
        uint256 timestamp;
    }

    Trigger[] public triggers;

    event TriggerLogged(string condition, string action, string source, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logTrigger(string calldata condition, string calldata action, string calldata source) external onlyAdmin {
        triggers.push(Trigger(condition, action, source, block.timestamp));
        emit TriggerLogged(condition, action, source, block.timestamp);
    }

    function totalTriggers() external view returns (uint256) {
        return triggers.length;
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title AuditChain
/// @notice Covenant contract to log citizen votes and allocations on-chain
contract AuditChain {
    address public owner;

    struct AuditLog {
        string action;       // e.g. "VoteCast", "FundsAllocated"
        address actor;       // who performed the action
        uint256 timestamp;   // block timestamp
        string details;      // extra info
    }

    AuditLog[] public logs;

    event ActionLogged(string action, address actor, uint256 timestamp, string details);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    function logAction(string memory action, address actor, string memory details) public onlyOwner {
        AuditLog memory newLog = AuditLog(action, actor, block.timestamp, details);
        logs.push(newLog);
        emit ActionLogged(action, actor, block.timestamp, details);
    }

    function getLog(uint256 index) public view returns (string memory, address, uint256, string memory) {
        AuditLog memory log = logs[index];
        return (log.action, log.actor, log.timestamp, log.details);
    }

    function getLogCount() public view returns (uint256) {
        return logs.length;
    }
}

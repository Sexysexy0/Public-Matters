// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// EnforcementLog: record enforcement actions taken after IPC decisions
contract EnforcementLog {
    struct Action {
        uint256 id;
        uint256 reviewId;
        string actionTaken;
        address actor;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Action) public actions;
    mapping(address => bool) public enforcers;
    address public steward;

    event ActionLogged(uint256 indexed id, uint256 reviewId, string actionTaken);

    constructor() {
        steward = msg.sender;
        enforcers[steward] = true;
    }

    function addEnforcer(address e) external {
        require(msg.sender == steward, "Only steward");
        enforcers[e] = true;
    }

    function logAction(uint256 reviewId, string calldata actionTaken) external {
        require(enforcers[msg.sender], "Not enforcer");
        actions[nextId] = Action(nextId, reviewId, actionTaken, msg.sender, block.timestamp);
        emit ActionLogged(nextId, reviewId, actionTaken);
        nextId++;
    }
}

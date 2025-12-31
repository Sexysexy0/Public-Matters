// contracts/WarMongeringAudit.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title WarMongeringAudit
 * @notice Logs audits of adversary war-mongering and aggressive actions.
 */
contract WarMongeringAudit {
    address public admin;

    struct Action {
        string actor;       // "CCP", "ProxyGroup"
        string description;
        uint256 timestamp;
    }

    Action[] public actions;

    event ActionLogged(string actor, string description, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logAction(string calldata actor, string calldata description) external onlyAdmin {
        actions.push(Action(actor, description, block.timestamp));
        emit ActionLogged(actor, description, block.timestamp);
    }

    function totalActions() external view returns (uint256) { return actions.length; }

    function getAction(uint256 id) external view returns (Action memory) {
        require(id < actions.length, "Invalid id");
        return actions[id];
    }
}

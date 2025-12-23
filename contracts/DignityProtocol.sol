// contracts/DignityProtocol.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title DignityProtocol
 * @notice Ensures communal dignity in media and public discourse.
 */
contract DignityProtocol {
    address public admin;

    struct Action {
        string actor;
        string measure;    // "BalancedCoverage", "FactCheck", "Transparency"
        string status;     // "Implemented", "Pending"
        uint256 timestamp;
    }

    Action[] public actions;

    event ActionLogged(string actor, string measure, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logAction(string calldata actor, string calldata measure, string calldata status) external onlyAdmin {
        actions.push(Action(actor, measure, status, block.timestamp));
        emit ActionLogged(actor, measure, status, block.timestamp);
    }

    function totalActions() external view returns (uint256) { return actions.length; }

    function getAction(uint256 id) external view returns (Action memory) {
        require(id < actions.length, "Invalid id");
        return actions[id];
    }
}

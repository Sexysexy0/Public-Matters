// contracts/HemisphereDominance.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title HemisphereDominance
 * @notice Logs Western Hemisphere dominance measures (Trump corollary to Monroe Doctrine).
 */
contract HemisphereDominance {
    address public admin;

    struct Action {
        string target;      // "ChinaAssets", "RussiaAssets", "MigrationControl", "DrugFlows"
        string status;      // "Active", "Pending"
        uint256 timestamp;
    }

    Action[] public actions;

    event ActionLogged(string target, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logAction(string calldata target, string calldata status) external onlyAdmin {
        actions.push(Action(target, status, block.timestamp));
        emit ActionLogged(target, status, block.timestamp);
    }

    function totalActions() external view returns (uint256) { return actions.length; }

    function getAction(uint256 id) external view returns (Action memory) {
        require(id < actions.length, "Invalid id");
        return actions[id];
    }
}

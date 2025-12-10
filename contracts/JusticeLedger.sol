// contracts/JusticeLedger.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title JusticeLedger
 * @notice Legal transparency, communal arbitration, restorative equity, and mythic dispute resolution.
 */
contract JusticeLedger {
    address public admin;

    struct Case {
        string title;
        string parties;
        string status;   // e.g., "Pending", "Resolved"
        string resolution;
        uint256 timestamp;
    }

    Case[] public cases;

    event CaseLogged(string title, string parties, string status, string resolution, uint256 timestamp);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function logCase(string calldata title, string calldata parties, string calldata status, string calldata resolution) external onlyAdmin {
        cases.push(Case(title, parties, status, resolution, block.timestamp));
        emit CaseLogged(title, parties, status, resolution, block.timestamp);
    }

    function totalCases() external view returns (uint256) {
        return cases.length;
    }

    function getCase(uint256 id) external view returns (Case memory) {
        require(id < cases.length, "Invalid id");
        return cases[id];
    }
}

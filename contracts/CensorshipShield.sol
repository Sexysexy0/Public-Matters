// contracts/CensorshipShield.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title CensorshipShield
 * @notice Logs censorship attempts and communal defense measures.
 */
contract CensorshipShield {
    address public admin;

    struct Case {
        string actor;       // "Government", "Platform"
        string description;
        string status;      // "Blocked", "Resisted"
        uint256 timestamp;
    }

    Case[] public cases;

    event CaseLogged(string actor, string description, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logCase(string calldata actor, string calldata description, string calldata status) external onlyAdmin {
        cases.push(Case(actor, description, status, block.timestamp));
        emit CaseLogged(actor, description, status, block.timestamp);
    }

    function totalCases() external view returns (uint256) { return cases.length; }

    function getCase(uint256 id) external view returns (Case memory) {
        require(id < cases.length, "Invalid id");
        return cases[id];
    }
}

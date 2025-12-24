// contracts/MisinformationAudit.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title MisinformationAudit
 * @notice Tracks misinformation cases and communal defense measures.
 */
contract MisinformationAudit {
    address public admin;

    struct Case {
        string source;      // "SocialMedia", "NewsOutlet"
        string description;
        string status;      // "Verified", "Debunked"
        uint256 timestamp;
    }

    Case[] public cases;

    event CaseLogged(string source, string description, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logCase(string calldata source, string calldata description, string calldata status) external onlyAdmin {
        cases.push(Case(source, description, status, block.timestamp));
        emit CaseLogged(source, description, status, block.timestamp);
    }

    function totalCases() external view returns (uint256) { return cases.length; }

    function getCase(uint256 id) external view returns (Case memory) {
        require(id < cases.length, "Invalid id");
        return cases[id];
    }
}

// contracts/PhishingAudit.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title PhishingAudit
 * @notice Tracks phishing attempts and communal equity in defense.
 */
contract PhishingAudit {
    address public admin;

    struct Attempt {
        string vector;      // "DiscordLink", "Email", "FakeWebsite"
        string description;
        string status;      // "Detected", "Blocked"
        uint256 timestamp;
    }

    Attempt[] public attempts;

    event AttemptLogged(string vector, string description, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logAttempt(string calldata vector, string calldata description, string calldata status) external onlyAdmin {
        attempts.push(Attempt(vector, description, status, block.timestamp));
        emit AttemptLogged(vector, description, status, block.timestamp);
    }

    function totalAttempts() external view returns (uint256) { return attempts.length; }

    function getAttempt(uint256 id) external view returns (Attempt memory) {
        require(id < attempts.length, "Invalid id");
        return attempts[id];
    }
}

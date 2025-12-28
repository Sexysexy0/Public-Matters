// contracts/AIEconomicImpact.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title AIEconomicImpact
 * @notice Logs AI contributions to GDP and sectoral shifts.
 */
contract AIEconomicImpact {
    address public admin;

    struct Contribution {
        string sector;      // "Manufacturing", "Healthcare", "Finance"
        uint256 percent;    // e.g. 15
        string description;
        uint256 timestamp;
    }

    Contribution[] public contributions;

    event ContributionLogged(string sector, uint256 percent, string description, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logContribution(string calldata sector, uint256 percent, string calldata description) external onlyAdmin {
        contributions.push(Contribution(sector, percent, description, block.timestamp));
        emit ContributionLogged(sector, percent, description, block.timestamp);
    }

    function totalContributions() external view returns (uint256) { return contributions.length; }

    function getContribution(uint256 id) external view returns (Contribution memory) {
        require(id < contributions.length, "Invalid id");
        return contributions[id];
    }
}

// contracts/AntiDisinformation.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title AntiDisinformation
 * @notice Protocol for tracking and countering disinformation campaigns.
 */
contract AntiDisinformation {
    address public admin;

    struct Campaign {
        string source;
        string narrative;
        string status;   // "Active", "Neutralized"
        uint256 timestamp;
    }

    Campaign[] public campaigns;

    event CampaignLogged(string source, string narrative, string status, uint256 timestamp);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function logCampaign(string calldata source, string calldata narrative, string calldata status) external onlyAdmin {
        campaigns.push(Campaign(source, narrative, status, block.timestamp));
        emit CampaignLogged(source, narrative, status, block.timestamp);
    }

    function totalCampaigns() external view returns (uint256) {
        return campaigns.length;
    }

    function getCampaign(uint256 id) external view returns (Campaign memory) {
        require(id < campaigns.length, "Invalid id");
        return campaigns[id];
    }
}

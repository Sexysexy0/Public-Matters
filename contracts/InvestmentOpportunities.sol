// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title InvestmentOpportunities
/// @notice Covenant contract to safeguard and incentivize undervalued real estate and supply chain investments in Mindanao
contract InvestmentOpportunities {
    address public owner;

    struct Opportunity {
        string sector;       // e.g. "Real Estate", "Supply Chain", "AgriTech"
        string description;  // details of the opportunity
        uint256 incentive;   // value of incentive or subsidy
        uint256 timestamp;
    }

    Opportunity[] public opportunities;

    event OpportunityLogged(string sector, string description, uint256 incentive, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Log a new investment opportunity
    function logOpportunity(string memory sector, string memory description, uint256 incentive) public onlyOwner {
        Opportunity memory newOpportunity = Opportunity(sector, description, incentive, block.timestamp);
        opportunities.push(newOpportunity);
        emit OpportunityLogged(sector, description, incentive, block.timestamp);
    }

    function getOpportunity(uint256 index) public view returns (string memory, string memory, uint256, uint256) {
        Opportunity memory o = opportunities[index];
        return (o.sector, o.description, o.incentive, o.timestamp);
    }

    function getOpportunityCount() public view returns (uint256) {
        return opportunities.length;
    }
}

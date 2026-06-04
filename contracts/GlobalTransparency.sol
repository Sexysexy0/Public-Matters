// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title GlobalTransparency
/// @notice Covenant contract to interconnect transparency dashboards across nations
contract GlobalTransparency {
    address public owner;

    struct Dashboard {
        string country;      // e.g. "Philippines", "Japan", "USA"
        string purpose;      // e.g. "Governance Outcomes", "Citizen Votes"
        address dashboardAddress; // linked TransparencyDAO contract
        uint256 timestamp;
    }

    Dashboard[] public dashboards;

    event DashboardRegistered(string country, string purpose, address dashboardAddress, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Register a new transparency dashboard
    function registerDashboard(string memory country, string memory purpose, address dashboardAddress) public onlyOwner {
        Dashboard memory newDashboard = Dashboard(country, purpose, dashboardAddress, block.timestamp);
        dashboards.push(newDashboard);
        emit DashboardRegistered(country, purpose, dashboardAddress, block.timestamp);
    }

    function getDashboard(uint256 index) public view returns (string memory, string memory, address, uint256) {
        Dashboard memory d = dashboards[index];
        return (d.country, d.purpose, d.dashboardAddress, d.timestamp);
    }

    function getDashboardCount() public view returns (uint256) {
        return dashboards.length;
    }
}

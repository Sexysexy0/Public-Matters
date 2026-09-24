// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ClimateAdaptationFinance Covenant
/// @notice Encodes renewable transition + adaptation finance governance
contract ClimateAdaptationFinance {
    address public admin;
    mapping(address => uint256) public projectFunds;

    event ProjectFunded(address indexed project, uint256 amount);

    constructor() {
        admin = msg.sender;
    }

    function fundProject(address project, uint256 amount) external {
        require(msg.sender == admin, "Only admin");
        projectFunds[project] += amount;
        emit ProjectFunded(project, amount);
    }

    function getFunds(address project) external view returns (uint256) {
        return projectFunds[project];
    }
}

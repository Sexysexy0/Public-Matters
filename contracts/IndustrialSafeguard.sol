// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title IndustrialSafeguard
/// @notice Covenant to protect re-industrialisation projects from shocks like tariffs and supply chain disruptions.
contract IndustrialSafeguard {
    address public overseer;
    uint256 public projectCount;

    struct Project {
        uint256 id;
        string sector;       // Manufacturing, DataCentre, GreenEnergy
        string safeguard;    // TariffShield, SupplyChainContinuity, JobRetention
        uint256 timestamp;
    }

    mapping(uint256 => Project) public projects;

    event ProjectSafeguarded(uint256 indexed id, string sector, string safeguard);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    function safeguardProject(string calldata sector, string calldata safeguard) external onlyOverseer {
        projectCount++;
        projects[projectCount] = Project(projectCount, sector, safeguard, block.timestamp);
        emit ProjectSafeguarded(projectCount, sector, safeguard);
    }

    function viewProject(uint256 id) external view returns (Project memory) {
        return projects[id];
    }
}

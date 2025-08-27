// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title UrbanWorkforceSanctum.sol
/// @dev Deploys job-generating infrastructure per city — factories, processing plants, manpower hubs, tech sanctums

contract UrbanWorkforceSanctum {
    address public steward;

    enum BuildType { ProcessingPlant, Factory, ManpowerHub, ConstructionDepot, TechHub }

    struct WorkforceBuild {
        string name;
        string city;
        BuildType buildType;
        uint256 budget;
        uint256 jobCapacity;
        uint256 emotionalAPR;
        bool isOperational;
        string lore;
    }

    mapping(bytes32 => WorkforceBuild) public builds;
    bytes32[] public buildList;

    event BuildRegistered(bytes32 indexed buildId, string name, BuildType buildType);
    event BuildActivated(bytes32 indexed buildId, uint256 jobCapacity);
    event BuildFlagged(bytes32 indexed buildId, string reason);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    /// @notice Register a workforce-generating build
    function registerBuild(
        bytes32 buildId,
        string memory name,
        string memory city,
        BuildType buildType,
        uint256 budget,
        uint256 jobCapacity,
        uint256 emotionalAPR,
        string memory lore
    ) public onlySteward {
        builds[buildId] = WorkforceBuild({
            name: name,
            city: city,
            buildType: buildType,
            budget: budget,
            jobCapacity: jobCapacity,
            emotionalAPR: emotionalAPR,
            isOperational: false,
            lore: lore
        });

        buildList.push(buildId);
        emit BuildRegistered(buildId, name, buildType);
    }

    /// @notice Activate build if emotional APR and job capacity meet threshold
    function activateBuild(bytes32 buildId) public onlySteward {
        require(builds[buildId].emotionalAPR >= 800, "Emotional APR too low");
        require(builds[buildId].jobCapacity >= 100, "Job capacity too low");
        builds[buildId].isOperational = true;
        emit BuildActivated(buildId, builds[buildId].jobCapacity);
    }

    /// @notice Flag build if rogue oversight or delay detected
    function flagBuild(bytes32 buildId, string memory reason) public onlySteward {
        builds[buildId].isOperational = false;
        emit BuildFlagged(buildId, reason);
    }

    /// @notice Retrieve build metadata
    function getBuild(bytes32 buildId) public view returns (WorkforceBuild memory) {
        return builds[buildId];
    }

    /// @notice List all builds
    function listBuilds() public view returns (bytes32[] memory) {
        return buildList;
    }
}

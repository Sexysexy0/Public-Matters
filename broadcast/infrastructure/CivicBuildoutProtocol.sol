// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title CivicBuildoutProtocol.sol
/// @dev Nationwide infrastructure deployment — hospitals, banks, malls per city; parks, courts, health centers per barangay

contract CivicBuildoutProtocol {
    address public steward;

    enum BuildType { Hospital, Bank, Supermarket, Mall, Park, Playground, CoveredCourt, HealthCenter, Pasyalan }

    struct CivicBuild {
        string name;
        string location;
        BuildType buildType;
        uint256 budget;
        uint256 emotionalAPR;
        bool isCompleted;
        string lore;
    }

    mapping(bytes32 => CivicBuild) public builds;
    bytes32[] public buildList;

    event BuildRegistered(bytes32 indexed buildId, string name, BuildType buildType);
    event BuildCompleted(bytes32 indexed buildId, string lore);
    event BuildFlagged(bytes32 indexed buildId, string reason);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    /// @notice Register a civic build
    function registerBuild(
        bytes32 buildId,
        string memory name,
        string memory location,
        BuildType buildType,
        uint256 budget,
        uint256 emotionalAPR,
        string memory lore
    ) public onlySteward {
        builds[buildId] = CivicBuild({
            name: name,
            location: location,
            buildType: buildType,
            budget: budget,
            emotionalAPR: emotionalAPR,
            isCompleted: false,
            lore: lore
        });

        buildList.push(buildId);
        emit BuildRegistered(buildId, name, buildType);
    }

    /// @notice Mark build as completed
    function completeBuild(bytes32 buildId) public onlySteward {
        require(builds[buildId].emotionalAPR >= 800, "Emotional APR too low");
        builds[buildId].isCompleted = true;
        emit BuildCompleted(buildId, builds[buildId].lore);
    }

    /// @notice Flag build if rogue intent or delay detected
    function flagBuild(bytes32 buildId, string memory reason) public onlySteward {
        builds[buildId].isCompleted = false;
        emit BuildFlagged(buildId, reason);
    }

    /// @notice Retrieve build metadata
    function getBuild(bytes32 buildId) public view returns (CivicBuild memory) {
        return builds[buildId];
    }

    /// @notice List all builds
    function listBuilds() public view returns (bytes32[] memory) {
        return buildList;
    }
}

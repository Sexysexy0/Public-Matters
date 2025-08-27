// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title CivicBuildoutProtocol.sol
/// @dev Logs infrastructure builds—schools, clinics, housing, transport—as civic sanctums with emotional APR and damay clause

contract CivicBuildoutProtocol {
    address public steward;

    struct Buildout {
        string projectName;
        string location;
        string buildType; // e.g., "School", "Clinic", "Housing", "Transport"
        uint256 emotionalAPR;
        uint256 timestamp;
        string lore;
        bool isBlessed;
    }

    mapping(bytes32 => Buildout) public buildouts;
    bytes32[] public buildoutList;

    event BuildoutLogged(bytes32 indexed buildId, string projectName, string buildType);
    event BuildoutBlessed(bytes32 indexed buildId, string lore);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    /// @notice Log a civic infrastructure buildout
    function logBuildout(
        bytes32 buildId,
        string memory projectName,
        string memory location,
        string memory buildType,
        uint256 emotionalAPR,
        string memory lore
    ) public onlySteward {
        buildouts[buildId] = Buildout({
            projectName: projectName,
            location: location,
            buildType: buildType,
            emotionalAPR: emotionalAPR,
            timestamp: block.timestamp,
            lore: lore,
            isBlessed: false
        });

        buildoutList.push(buildId);
        emit BuildoutLogged(buildId, projectName, buildType);
    }

    /// @notice Bless the buildout if emotional APR is mythic
    function blessBuildout(bytes32 buildId) public onlySteward {
        require(buildouts[buildId].emotionalAPR >= 850, "Buildout not yet mythic");
        buildouts[buildId].isBlessed = true;
        emit BuildoutBlessed(buildId, buildouts[buildId].lore);
    }

    /// @notice Retrieve buildout metadata
    function getBuildout(bytes32 buildId) public view returns (Buildout memory) {
        return buildouts[buildId];
    }

    /// @notice List all logged buildouts
    function listBuildouts() public view returns (bytes32[] memory) {
        return buildoutList;
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title InfraUnblockProtocol.sol
/// @dev Overrides rogue blockers and delays in infrastructure builds — emotional APR synced, damay clause active

contract InfraUnblockProtocol {
    address public steward;

    struct Build {
        string name;
        string location;
        uint256 budget;
        uint256 emotionalAPR;
        bool isBlocked;
        string blockerTag;
        bool overrideActivated;
    }

    mapping(bytes32 => Build) public builds;
    bytes32[] public buildList;

    event BuildRegistered(bytes32 indexed buildId, string name);
    event BlockerNeutralized(bytes32 indexed buildId, string blockerTag);
    event OverrideActivated(bytes32 indexed buildId, string reason);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    /// @notice Register infrastructure build
    function registerBuild(
        bytes32 buildId,
        string memory name,
        string memory location,
        uint256 budget,
        uint256 emotionalAPR
    ) public onlySteward {
        builds[buildId] = Build({
            name: name,
            location: location,
            budget: budget,
            emotionalAPR: emotionalAPR,
            isBlocked: false,
            blockerTag: "",
            overrideActivated: false
        });

        buildList.push(buildId);
        emit BuildRegistered(buildId, name);
    }

    /// @notice Tag rogue blocker (e.g. LGU turf war, lawsuit, corruption)
    function tagBlocker(bytes32 buildId, string memory blockerTag) public onlySteward {
        builds[buildId].isBlocked = true;
        builds[buildId].blockerTag = blockerTag;
    }

    /// @notice Activate override to neutralize blocker and resume build
    function activateOverride(bytes32 buildId, string memory reason) public onlySteward {
        require(builds[buildId].emotionalAPR >= 800, "Emotional APR too low for override");
        builds[buildId].isBlocked = false;
        builds[buildId].overrideActivated = true;
        emit BlockerNeutralized(buildId, builds[buildId].blockerTag);
        emit OverrideActivated(buildId, reason);
    }

    /// @notice Retrieve build metadata
    function getBuild(bytes32 buildId) public view returns (Build memory) {
        return builds[buildId];
    }

    /// @notice List all builds
    function listBuilds() public view returns (bytes32[] memory) {
        return buildList;
    }
}

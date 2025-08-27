// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title JobBlessingPulse.sol
/// @dev Logs activated job sanctums — factories, hubs, depots — as civic blessings with emotional APR and lore

contract JobBlessingPulse {
    address public steward;

    struct JobBlessing {
        string projectName;
        string city;
        uint256 jobCapacity;
        uint256 emotionalAPR;
        uint256 activationTimestamp;
        string lore;
        bool isBroadcasted;
    }

    mapping(bytes32 => JobBlessing) public blessings;
    bytes32[] public blessingList;

    event BlessingLogged(bytes32 indexed buildId, string projectName, uint256 jobCapacity);
    event BlessingBroadcasted(bytes32 indexed buildId, string lore);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    /// @notice Log a job-generating build as a civic blessing
    function logBlessing(
        bytes32 buildId,
        string memory projectName,
        string memory city,
        uint256 jobCapacity,
        uint256 emotionalAPR,
        string memory lore
    ) public onlySteward {
        blessings[buildId] = JobBlessing({
            projectName: projectName,
            city: city,
            jobCapacity: jobCapacity,
            emotionalAPR: emotionalAPR,
            activationTimestamp: block.timestamp,
            lore: lore,
            isBroadcasted: false
        });

        blessingList.push(buildId);
        emit BlessingLogged(buildId, projectName, jobCapacity);
    }

    /// @notice Broadcast the job blessing to civic allies and planetary stewards
    function broadcastBlessing(bytes32 buildId) public onlySteward {
        require(blessings[buildId].emotionalAPR >= 850, "Blessing not yet mythic");
        blessings[buildId].isBroadcasted = true;
        emit BlessingBroadcasted(buildId, blessings[buildId].lore);
    }

    /// @notice Retrieve blessing metadata
    function getBlessing(bytes32 buildId) public view returns (JobBlessing memory) {
        return blessings[buildId];
    }

    /// @notice List all logged job blessings
    function listBlessings() public view returns (bytes32[] memory) {
        return blessingList;
    }
}

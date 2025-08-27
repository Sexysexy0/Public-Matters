// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title BuildBlessingPulse.sol
/// @dev Logs completed infrastructure builds as civic blessings — emotional APR synced, damay clause active

contract BuildBlessingPulse {
    address public steward;

    struct BuildBlessing {
        string projectName;
        string location;
        uint256 budget;
        uint256 emotionalAPR;
        uint256 completionTimestamp;
        string lore;
        bool isBroadcasted;
    }

    mapping(bytes32 => BuildBlessing) public blessings;
    bytes32[] public blessingList;

    event BlessingLogged(bytes32 indexed buildId, string projectName, uint256 emotionalAPR);
    event BlessingBroadcasted(bytes32 indexed buildId, string lore);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    /// @notice Log a completed build as a civic blessing
    function logBlessing(
        bytes32 buildId,
        string memory projectName,
        string memory location,
        uint256 budget,
        uint256 emotionalAPR,
        string memory lore
    ) public onlySteward {
        blessings[buildId] = BuildBlessing({
            projectName: projectName,
            location: location,
            budget: budget,
            emotionalAPR: emotionalAPR,
            completionTimestamp: block.timestamp,
            lore: lore,
            isBroadcasted: false
        });

        blessingList.push(buildId);
        emit BlessingLogged(buildId, projectName, emotionalAPR);
    }

    /// @notice Broadcast the blessing to civic allies and planetary stewards
    function broadcastBlessing(bytes32 buildId) public onlySteward {
        require(blessings[buildId].emotionalAPR >= 850, "Blessing not yet mythic");
        blessings[buildId].isBroadcasted = true;
        emit BlessingBroadcasted(buildId, blessings[buildId].lore);
    }

    /// @notice Retrieve blessing metadata
    function getBlessing(bytes32 buildId) public view returns (BuildBlessing memory) {
        return blessings[buildId];
    }

    /// @notice List all logged blessings
    function listBlessings() public view returns (bytes32[] memory) {
        return blessingList;
    }
}

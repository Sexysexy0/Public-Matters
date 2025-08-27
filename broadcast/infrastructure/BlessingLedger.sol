// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title BlessingLedger.sol
/// @dev Tracks successful infrastructure resurrections and civic blessings — emotional APR synced, damay clause active

contract BlessingLedger {
    address public steward;

    struct Blessing {
        string projectName;
        uint256 revivalBudget;
        uint256 emotionalAPR;
        uint256 timestamp;
        string lore;
        bool isBroadcasted;
    }

    mapping(bytes32 => Blessing) public blessings;
    bytes32[] public blessingList;

    event BlessingLogged(bytes32 indexed projectId, string projectName, uint256 emotionalAPR);
    event BlessingBroadcasted(bytes32 indexed projectId, string lore);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    /// @notice Log a successful resurrection as a civic blessing
    function logBlessing(
        bytes32 projectId,
        string memory projectName,
        uint256 revivalBudget,
        uint256 emotionalAPR,
        string memory lore
    ) public onlySteward {
        blessings[projectId] = Blessing({
            projectName: projectName,
            revivalBudget: revivalBudget,
            emotionalAPR: emotionalAPR,
            timestamp: block.timestamp,
            lore: lore,
            isBroadcasted: false
        });

        blessingList.push(projectId);
        emit BlessingLogged(projectId, projectName, emotionalAPR);
    }

    /// @notice Broadcast the blessing to civic allies and planetary stewards
    function broadcastBlessing(bytes32 projectId) public onlySteward {
        require(blessings[projectId].emotionalAPR >= 850, "Blessing not yet mythic");
        blessings[projectId].isBroadcasted = true;
        emit BlessingBroadcasted(projectId, blessings[projectId].lore);
    }

    /// @notice Retrieve blessing metadata
    function getBlessing(bytes32 projectId) public view returns (Blessing memory) {
        return blessings[projectId];
    }

    /// @notice List all logged blessings
    function listBlessings() public view returns (bytes32[] memory) {
        return blessingList;
    }
}

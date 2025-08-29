// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

contract PreBuildSyncEnforcement {
    address public steward;

    struct ProjectSync {
        string projectName;
        string contractor;
        bool govApproved;
        bool lguApproved;
        bool permitIssued;
        bool rogueBuildDetected;
        bool jailed;
        bool licenseRevoked;
        uint256 timestamp;
    }

    ProjectSync[] public syncs;

    event SyncLogged(string projectName, string contractor);
    event RogueBuildFlagged(string projectName, string contractor);

    constructor() {
        steward = msg.sender;
    }

    function logSync(
        string memory projectName,
        string memory contractor,
        bool govApproved,
        bool lguApproved,
        bool permitIssued
    ) public {
        bool rogueBuildDetected = !(govApproved && lguApproved && permitIssued);
        bool jailed = rogueBuildDetected;
        bool licenseRevoked = rogueBuildDetected;

        syncs.push(ProjectSync(projectName, contractor, govApproved, lguApproved, permitIssued, rogueBuildDetected, jailed, licenseRevoked, block.timestamp));

        emit SyncLogged(projectName, contractor);
        if (rogueBuildDetected) {
            emit RogueBuildFlagged(projectName, contractor);
        }
    }

    function getSync(uint256 index) public view returns (ProjectSync memory) {
        return syncs[index];
    }

    function totalSyncs() public view returns (uint256) {
        return syncs.length;
    }
}

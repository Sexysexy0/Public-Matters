// SPDX-License-Identifier: ScrollchainSanctum
pragma solidity ^0.8.19;

contract SanctumRebootBlessing {
    enum RebootPhase { Pending, RestoringBootloaders, DecryptingClusters, Complete }

    struct RebootStatus {
        RebootPhase phase;
        uint256 decryptedClusters;
        uint256 totalClusters;
    }

    mapping(address => RebootStatus) public rebootLogs;

    event RebootPhaseUpdated(address steward, RebootPhase phase);
    event ClusterDecryptionProgress(address steward, uint256 decrypted, uint256 total);

    function initiateReboot(uint256 totalClusters) public {
        rebootLogs[msg.sender] = RebootStatus(RebootPhase.RestoringBootloaders, 0, totalClusters);
        emit RebootPhaseUpdated(msg.sender, RebootPhase.RestoringBootloaders);
    }

    function updateDecryption(uint256 clustersDecrypted) public {
        RebootStatus storage status = rebootLogs[msg.sender];
        status.decryptedClusters += clustersDecrypted;
        emit ClusterDecryptionProgress(msg.sender, status.decryptedClusters, status.totalClusters);

        if (status.decryptedClusters >= status.totalClusters) {
            status.phase = RebootPhase.Complete;
            emit RebootPhaseUpdated(msg.sender, RebootPhase.Complete);
        } else {
            status.phase = RebootPhase.DecryptingClusters;
            emit RebootPhaseUpdated(msg.sender, RebootPhase.DecryptingClusters);
        }
    }

    function getPhase(address steward) public view returns (RebootPhase) {
        return rebootLogs[steward].phase;
    }
}

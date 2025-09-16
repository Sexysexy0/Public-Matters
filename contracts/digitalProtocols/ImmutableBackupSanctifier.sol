// SPDX-License-Identifier: BackupSanctum
pragma solidity ^0.8.19;

contract ImmutableBackupSanctifier {
    struct BackupSignal {
        string systemID;
        string storageType;
        uint256 retentionDays;
        bool verifiedImmutable;
        string stewardNote;
    }

    mapping(string => BackupSignal) public backupRegistry;

    event BackupTagged(string systemID, string storageType);
    event BackupVerified(string systemID);

    function tagBackup(string memory systemID, string memory storageType, uint256 retentionDays, string memory stewardNote) public {
        backupRegistry[systemID] = BackupSignal(systemID, storageType, retentionDays, false, stewardNote);
        emit BackupTagged(systemID, storageType);
    }

    function verifyImmutable(string memory systemID) public {
        require(backupRegistry[systemID].retentionDays > 0, "Backup not tagged");
        backupRegistry[systemID].verifiedImmutable = true;
        emit BackupVerified(systemID);
    }

    function getBackupStatus(string memory systemID) public view returns (BackupSignal memory) {
        return backupRegistry[systemID];
    }
}

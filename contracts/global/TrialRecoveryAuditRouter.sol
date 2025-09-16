// SPDX-License-Identifier: TrialRecoverySanctum
pragma solidity ^0.8.19;

contract TrialRecoveryAuditRouter {
    struct RecoverySignal {
        string fileHash;
        string fileType;
        bool decrypted;
        string ransomNoteHash;
        string stewardNote;
    }

    mapping(string => RecoverySignal) public recoveryRegistry;

    event TrialFileTagged(string fileHash, string fileType);
    event DecryptionVerified(string fileHash);

    function tagTrialFile(string memory fileHash, string memory fileType, string memory ransomNoteHash, string memory stewardNote) public {
        recoveryRegistry[fileHash] = RecoverySignal(fileHash, fileType, false, ransomNoteHash, stewardNote);
        emit TrialFileTagged(fileHash, fileType);
    }

    function verifyDecryption(string memory fileHash) public {
        require(bytes(recoveryRegistry[fileHash].fileType).length > 0, "File not tagged");
        recoveryRegistry[fileHash].decrypted = true;
        emit DecryptionVerified(fileHash);
    }

    function getRecoveryStatus(string memory fileHash) public view returns (RecoverySignal memory) {
        return recoveryRegistry[fileHash];
    }
}

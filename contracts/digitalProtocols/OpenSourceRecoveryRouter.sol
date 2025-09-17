// SPDX-License-Identifier: RecoverySanctum
pragma solidity ^0.8.19;

contract OpenSourceRecoveryRouter {
    struct RecoverySignal {
        address repoID;
        string repoName;
        string breachType; // e.g., "Credential Leak", "Worm Propagation", "CI/CD Compromise"
        bool auditCompleted;
        bool remediationDeployed;
        string stewardNote;
    }

    mapping(address => RecoverySignal) public recoveryRegistry;

    event RecoveryTagged(address repoID, string breachType);
    event RecoverySanctified(address repoID);

    function tagRecovery(
        address repoID,
        string memory repoName,
        string memory breachType,
        bool auditCompleted,
        bool remediationDeployed,
        string memory stewardNote
    ) public {
        recoveryRegistry[repoID] = RecoverySignal(
            repoID,
            repoName,
            breachType,
            auditCompleted,
            remediationDeployed,
            stewardNote
        );
        emit RecoveryTagged(repoID, breachType);
    }

    function sanctifyRecovery(address repoID) public {
        require(bytes(recoveryRegistry[repoID].repoName).length > 0, "Recovery not tagged");
        recoveryRegistry[repoID].remediationDeployed = true;
        emit RecoverySanctified(repoID);
    }

    function getRecoveryStatus(address repoID) public view returns (RecoverySignal memory) {
        return recoveryRegistry[repoID];
    }
}

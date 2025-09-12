// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RegionalRecoveryRouter {
    enum RecoveryType { Infrastructure, Housing, SMESupport, CulturalPreservation }

    struct RecoverySignal {
        uint256 id;
        string region;
        RecoveryType recoveryType;
        uint256 budgetAllocated;
        string clauseReference;
        uint256 timestamp;
    }

    mapping(uint256 => RecoverySignal) public recoveryRegistry;
    uint256 public recoveryCount;

    event RecoveryLogged(uint256 id, string region, RecoveryType recoveryType);

    function logRecovery(
        string memory region,
        RecoveryType recoveryType,
        uint256 budgetAllocated,
        string memory clauseReference,
        uint256 timestamp
    ) public {
        recoveryRegistry[recoveryCount] = RecoverySignal(
            recoveryCount,
            region,
            recoveryType,
            budgetAllocated,
            clauseReference,
            timestamp
        );
        emit RecoveryLogged(recoveryCount, region, recoveryType);
        recoveryCount++;
    }

    function getRecovery(uint256 id) public view returns (RecoverySignal memory) {
        return recoveryRegistry[id];
    }
}

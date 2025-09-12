// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DemocracyProtectionProtocol {
    enum ProtectionType { PressFreedom, CivicExpression, AntiCensorship, LegalShield }

    struct ProtectionSignal {
        uint256 id;
        string entity;
        ProtectionType protectionType;
        string clauseReference;
        uint256 timestamp;
    }

    mapping(uint256 => ProtectionSignal) public protectionRegistry;
    uint256 public protectionCount;

    event ProtectionLogged(uint256 id, string entity, ProtectionType protectionType);

    function logProtection(
        string memory entity,
        ProtectionType protectionType,
        string memory clauseReference,
        uint256 timestamp
    ) public {
        protectionRegistry[protectionCount] = ProtectionSignal(
            protectionCount,
            entity,
            protectionType,
            clauseReference,
            timestamp
        );
        emit ProtectionLogged(protectionCount, entity, protectionType);
        protectionCount++;
    }

    function getProtection(uint256 id) public view returns (ProtectionSignal memory) {
        return protectionRegistry[id];
    }
}

// SPDX-License-Identifier: AuditSanctum
pragma solidity ^0.8.19;

contract MuleAccountAuditLedger {
    struct FreezeEvent {
        address account;
        string bankName;
        bool flaggedAsMule;
        bool innocent;
        string merchantType;
        string auditNote;
        bool restored;
    }

    mapping(address => FreezeEvent) public freezeRecords;

    event FreezeTagged(address account, string bankName);
    event InnocenceConfirmed(address account);

    function tagFreeze(address account, string memory bankName, bool flaggedAsMule, string memory merchantType, string memory auditNote) public {
        freezeRecords[account] = FreezeEvent(account, bankName, flaggedAsMule, false, merchantType, auditNote, false);
        emit FreezeTagged(account, bankName);
    }

    function confirmInnocence(address account) public {
        freezeRecords[account].innocent = true;
        freezeRecords[account].restored = true;
        emit InnocenceConfirmed(account);
    }

    function getFreezeStatus(address account) public view returns (FreezeEvent memory) {
        return freezeRecords[account];
    }
}

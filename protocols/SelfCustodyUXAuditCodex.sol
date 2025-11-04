// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SelfCustodyUXAuditCodex {
    address public steward;

    struct UXAuditEntry {
        string walletName;
        string UXChallenge;
        string auditSignal;
        string emotionalTag;
    }

    UXAuditEntry[] public codex;

    event SelfCustodyUXAudited(string walletName, string UXChallenge, string auditSignal, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function auditUX(
        string memory walletName,
        string memory UXChallenge,
        string memory auditSignal,
        string memory emotionalTag
    ) public onlySteward {
        codex.push(UXAuditEntry(walletName, UXChallenge, auditSignal, emotionalTag));
        emit SelfCustodyUXAudited(walletName, UXChallenge, auditSignal, emotionalTag);
    }
}

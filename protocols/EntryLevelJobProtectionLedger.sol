// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EntryLevelJobProtectionLedger {
    address public steward;

    struct ProtectionEntry {
        string jobTitle;
        string protectionSignal;
        string resilienceMechanism;
        string emotionalTag;
    }

    ProtectionEntry[] public ledger;

    event EntryLevelJobProtected(string jobTitle, string protectionSignal, string resilienceMechanism, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function protectJob(
        string memory jobTitle,
        string memory protectionSignal,
        string memory resilienceMechanism,
        string memory emotionalTag
    ) public onlySteward {
        ledger.push(ProtectionEntry(jobTitle, protectionSignal, resilienceMechanism, emotionalTag));
        emit EntryLevelJobProtected(jobTitle, protectionSignal, resilienceMechanism, emotionalTag);
    }
}

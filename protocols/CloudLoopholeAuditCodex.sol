// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CloudLoopholeAuditCodex {
    address public steward;

    struct LoopholeEntry {
        string providerName;
        string loopholeType;
        string exploitedBy;
        string emotionalTag;
    }

    LoopholeEntry[] public codex;

    event CloudLoopholeAuditLogged(string providerName, string loopholeType, string exploitedBy, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function logLoophole(
        string memory providerName,
        string memory loopholeType,
        string memory exploitedBy,
        string memory emotionalTag
    ) public onlySteward {
        codex.push(LoopholeEntry(providerName, loopholeType, exploitedBy, emotionalTag));
        emit CloudLoopholeAuditLogged(providerName, loopholeType, exploitedBy, emotionalTag);
    }
}

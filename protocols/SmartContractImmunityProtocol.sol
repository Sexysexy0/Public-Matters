// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SmartContractImmunityProtocol {
    address public steward;

    struct ImmunityEntry {
        string protocolName;
        string auditFirm;
        string immunityLevel;
        string emotionalTag;
    }

    ImmunityEntry[] public registry;

    event SmartContractImmunityTagged(string protocolName, string auditFirm, string immunityLevel, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagImmunity(
        string memory protocolName,
        string memory auditFirm,
        string memory immunityLevel,
        string memory emotionalTag
    ) public onlySteward {
        registry.push(ImmunityEntry(protocolName, auditFirm, immunityLevel, emotionalTag));
        emit SmartContractImmunityTagged(protocolName, auditFirm, immunityLevel, emotionalTag);
    }
}

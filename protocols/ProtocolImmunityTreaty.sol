// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ProtocolImmunityTreaty {
    address public steward;

    struct ImmunityClause {
        string protocolName;
        string immunitySource;
        string protectionScope;
        string emotionalTag;
    }

    ImmunityClause[] public treatyLog;

    event ProtocolImmunityTagged(string protocolName, string immunitySource, string protectionScope, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagImmunity(
        string memory protocolName,
        string memory immunitySource,
        string memory protectionScope,
        string memory emotionalTag
    ) public onlySteward {
        treatyLog.push(ImmunityClause(protocolName, immunitySource, protectionScope, emotionalTag));
        emit ProtocolImmunityTagged(protocolName, immunitySource, protectionScope, emotionalTag);
    }
}

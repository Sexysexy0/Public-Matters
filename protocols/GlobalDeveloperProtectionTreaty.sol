// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GlobalDeveloperProtectionTreaty {
    address public steward;

    struct ProtectionClause {
        string developerName;
        string jurisdiction;
        string protectionFramework;
        string emotionalTag;
    }

    ProtectionClause[] public treatyLog;

    event GlobalDeveloperProtectionTagged(string developerName, string jurisdiction, string protectionFramework, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagProtection(
        string memory developerName,
        string memory jurisdiction,
        string memory protectionFramework,
        string memory emotionalTag
    ) public onlySteward {
        treatyLog.push(ProtectionClause(developerName, jurisdiction, protectionFramework, emotionalTag));
        emit GlobalDeveloperProtectionTagged(developerName, jurisdiction, protectionFramework, emotionalTag);
    }
}

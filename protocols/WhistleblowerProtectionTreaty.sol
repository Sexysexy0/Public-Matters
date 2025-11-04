// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract WhistleblowerProtectionTreaty {
    address public steward;

    struct ProtectionClause {
        string whistleblowerName;
        string caseType;
        string protectionLevel;
        string emotionalTag;
    }

    ProtectionClause[] public treatyLog;

    event WhistleblowerProtected(string whistleblowerName, string caseType, string protectionLevel, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function protectWhistleblower(
        string memory whistleblowerName,
        string memory caseType,
        string memory protectionLevel,
        string memory emotionalTag
    ) public onlySteward {
        treatyLog.push(ProtectionClause(whistleblowerName, caseType, protectionLevel, emotionalTag));
        emit WhistleblowerProtected(whistleblowerName, caseType, protectionLevel, emotionalTag);
    }
}

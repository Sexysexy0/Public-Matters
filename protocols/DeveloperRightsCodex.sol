// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DeveloperRightsCodex {
    address public steward;

    struct RightsEntry {
        string developerName;
        string threatenedRight;
        string defenseClause;
        string emotionalTag;
    }

    RightsEntry[] public codex;

    event DeveloperRightTagged(string developerName, string threatenedRight, string defenseClause, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagRight(
        string memory developerName,
        string memory threatenedRight,
        string memory defenseClause,
        string memory emotionalTag
    ) public onlySteward {
        codex.push(RightsEntry(developerName, threatenedRight, defenseClause, emotionalTag));
        emit DeveloperRightTagged(developerName, threatenedRight, defenseClause, emotionalTag);
    }
}

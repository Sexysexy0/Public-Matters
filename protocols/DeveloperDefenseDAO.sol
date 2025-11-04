// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DeveloperDefenseDAO {
    address public steward;

    struct DefenseEntry {
        string developerName;
        string threatType;
        string defenseStrategy;
        string emotionalTag;
    }

    DefenseEntry[] public registry;

    event DeveloperDefenseTagged(string developerName, string threatType, string defenseStrategy, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagDefense(
        string memory developerName,
        string memory threatType,
        string memory defenseStrategy,
        string memory emotionalTag
    ) public onlySteward {
        registry.push(DefenseEntry(developerName, threatType, defenseStrategy, emotionalTag));
        emit DeveloperDefenseTagged(developerName, threatType, defenseStrategy, emotionalTag);
    }
}

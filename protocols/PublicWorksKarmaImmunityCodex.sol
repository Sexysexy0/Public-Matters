// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PublicWorksKarmaImmunityCodex {
    address public steward;

    struct ImmunityEntry {
        string projectName;
        string karmaSignal;
        string immunityMechanism;
        string emotionalTag;
    }

    ImmunityEntry[] public codex;

    event PublicWorkKarmaImmunized(string projectName, string karmaSignal, string immunityMechanism, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function immunizePublicWork(
        string memory projectName,
        string memory karmaSignal,
        string memory immunityMechanism,
        string memory emotionalTag
    ) public onlySteward {
        codex.push(ImmunityEntry(projectName, karmaSignal, immunityMechanism, emotionalTag));
        emit PublicWorkKarmaImmunized(projectName, karmaSignal, immunityMechanism, emotionalTag);
    }
}

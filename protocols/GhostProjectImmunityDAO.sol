// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GhostProjectImmunityDAO {
    address public steward;

    struct ImmunityEntry {
        string projectName;
        string anomalyType;
        string auditSignal;
        string emotionalTag;
    }

    ImmunityEntry[] public registry;

    event GhostProjectTagged(string projectName, string anomalyType, string auditSignal, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagGhostProject(
        string memory projectName,
        string memory anomalyType,
        string memory auditSignal,
        string memory emotionalTag
    ) public onlySteward {
        registry.push(ImmunityEntry(projectName, anomalyType, auditSignal, emotionalTag));
        emit GhostProjectTagged(projectName, anomalyType, auditSignal, emotionalTag);
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GhostProjectForgivenessDAO {
    address public steward;

    struct ForgivenessEntry {
        string projectName;
        string anomalyType;
        string forgivenessMechanism;
        string emotionalTag;
    }

    ForgivenessEntry[] public registry;

    event GhostProjectForgiven(string projectName, string anomalyType, string forgivenessMechanism, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function forgiveGhostProject(
        string memory projectName,
        string memory anomalyType,
        string memory forgivenessMechanism,
        string memory emotionalTag
    ) public onlySteward {
        registry.push(ForgivenessEntry(projectName, anomalyType, forgivenessMechanism, emotionalTag));
        emit GhostProjectForgiven(projectName, anomalyType, forgivenessMechanism, emotionalTag);
    }
}

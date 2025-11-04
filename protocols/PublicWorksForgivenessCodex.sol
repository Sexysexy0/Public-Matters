// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PublicWorksForgivenessCodex {
    address public steward;

    struct ForgivenessEntry {
        string projectName;
        string anomalyType;
        string forgivenessMechanism;
        string emotionalTag;
    }

    ForgivenessEntry[] public codex;

    event PublicWorkForgiven(string projectName, string anomalyType, string forgivenessMechanism, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function forgivePublicWork(
        string memory projectName,
        string memory anomalyType,
        string memory forgivenessMechanism,
        string memory emotionalTag
    ) public onlySteward {
        codex.push(ForgivenessEntry(projectName, anomalyType, forgivenessMechanism, emotionalTag));
        emit PublicWorkForgiven(projectName, anomalyType, forgivenessMechanism, emotionalTag);
    }
}

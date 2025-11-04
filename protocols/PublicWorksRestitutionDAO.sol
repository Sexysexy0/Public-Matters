// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PublicWorksRestitutionDAO {
    address public steward;

    struct RestitutionEntry {
        string projectName;
        string restitutionSignal;
        string communityMetric;
        string emotionalTag;
    }

    RestitutionEntry[] public registry;

    event PublicWorkRestituted(string projectName, string restitutionSignal, string communityMetric, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function restitutePublicWork(
        string memory projectName,
        string memory restitutionSignal,
        string memory communityMetric,
        string memory emotionalTag
    ) public onlySteward {
        registry.push(RestitutionEntry(projectName, restitutionSignal, communityMetric, emotionalTag));
        emit PublicWorkRestituted(projectName, restitutionSignal, communityMetric, emotionalTag);
    }
}

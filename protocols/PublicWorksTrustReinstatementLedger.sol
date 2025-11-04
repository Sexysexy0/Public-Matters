// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PublicWorksTrustReinstatementLedger {
    address public steward;

    struct TrustEntry {
        string projectName;
        string reinstatementSignal;
        string communityMetric;
        string emotionalTag;
    }

    TrustEntry[] public ledger;

    event PublicWorkTrustReinstated(string projectName, string reinstatementSignal, string communityMetric, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function reinstateTrust(
        string memory projectName,
        string memory reinstatementSignal,
        string memory communityMetric,
        string memory emotionalTag
    ) public onlySteward {
        ledger.push(TrustEntry(projectName, reinstatementSignal, communityMetric, emotionalTag));
        emit PublicWorkTrustReinstated(projectName, reinstatementSignal, communityMetric, emotionalTag);
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PublicWorksTransparencyLedger {
    address public steward;

    struct TransparencyEntry {
        string projectName;
        string location;
        string auditStatus;
        string emotionalTag;
    }

    TransparencyEntry[] public ledger;

    event PublicWorkTagged(string projectName, string location, string auditStatus, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagPublicWork(
        string memory projectName,
        string memory location,
        string memory auditStatus,
        string memory emotionalTag
    ) public onlySteward {
        ledger.push(TransparencyEntry(projectName, location, auditStatus, emotionalTag));
        emit PublicWorkTagged(projectName, location, auditStatus, emotionalTag);
    }
}

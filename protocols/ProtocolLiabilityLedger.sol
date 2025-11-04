// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ProtocolLiabilityLedger {
    address public steward;

    struct LiabilityEntry {
        string protocolName;
        string liabilityTrigger;
        string legalExposure;
        string emotionalTag;
    }

    LiabilityEntry[] public registry;

    event ProtocolLiabilityTagged(string protocolName, string liabilityTrigger, string legalExposure, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagLiability(
        string memory protocolName,
        string memory liabilityTrigger,
        string memory legalExposure,
        string memory emotionalTag
    ) public onlySteward {
        registry.push(LiabilityEntry(protocolName, liabilityTrigger, legalExposure, emotionalTag));
        emit ProtocolLiabilityTagged(protocolName, liabilityTrigger, legalExposure, emotionalTag);
    }
}

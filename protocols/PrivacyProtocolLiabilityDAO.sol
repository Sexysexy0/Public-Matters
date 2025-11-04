// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PrivacyProtocolLiabilityDAO {
    address public steward;

    struct LiabilityEntry {
        string protocolName;
        string legalCase;
        string developerRisk;
        string emotionalTag;
    }

    LiabilityEntry[] public registry;

    event PrivacyProtocolLiabilityTagged(string protocolName, string legalCase, string developerRisk, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagLiability(
        string memory protocolName,
        string memory legalCase,
        string memory developerRisk,
        string memory emotionalTag
    ) public onlySteward {
        registry.push(LiabilityEntry(protocolName, legalCase, developerRisk, emotionalTag));
        emit PrivacyProtocolLiabilityTagged(protocolName, legalCase, developerRisk, emotionalTag);
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract ValidatorRiskLedger {
    address public steward;

    struct RiskEntry {
        string validatorName;
        string network;
        string riskFactor;
        string emotionalTag;
    }

    RiskEntry[] public registry;

    event ValidatorRiskTagged(string validatorName, string network, string riskFactor, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagRisk(
        string memory validatorName,
        string memory network,
        string memory riskFactor,
        string memory emotionalTag
    ) public onlySteward {
        registry.push(RiskEntry(validatorName, network, riskFactor, emotionalTag));
        emit ValidatorRiskTagged(validatorName, network, riskFactor, emotionalTag);
    }
}

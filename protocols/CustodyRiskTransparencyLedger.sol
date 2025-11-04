// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CustodyRiskTransparencyLedger {
    address public steward;

    struct RiskEntry {
        string custodyProvider;
        string riskType;
        string transparencySignal;
        string emotionalTag;
    }

    RiskEntry[] public ledger;

    event CustodyRiskTagged(string custodyProvider, string riskType, string transparencySignal, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagRisk(
        string memory custodyProvider,
        string memory riskType,
        string memory transparencySignal,
        string memory emotionalTag
    ) public onlySteward {
        ledger.push(RiskEntry(custodyProvider, riskType, transparencySignal, emotionalTag));
        emit CustodyRiskTagged(custodyProvider, riskType, transparencySignal, emotionalTag);
    }
}

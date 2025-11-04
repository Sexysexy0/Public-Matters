// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract GlobalMonetaryPolicyConvergenceLedger {
    address public steward;

    struct ConvergenceEntry {
        string centralBank;
        string policySignal;
        string cryptoImpact;
        string emotionalTag;
    }

    ConvergenceEntry[] public ledger;

    event MonetaryPolicyConvergenceTagged(string centralBank, string policySignal, string cryptoImpact, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagConvergence(
        string memory centralBank,
        string memory policySignal,
        string memory cryptoImpact,
        string memory emotionalTag
    ) public onlySteward {
        ledger.push(ConvergenceEntry(centralBank, policySignal, cryptoImpact, emotionalTag));
        emit MonetaryPolicyConvergenceTagged(centralBank, policySignal, cryptoImpact, emotionalTag);
    }
}

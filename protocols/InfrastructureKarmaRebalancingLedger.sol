// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract InfrastructureKarmaRebalancingLedger {
    address public steward;

    struct KarmaEntry {
        string region;
        string karmaImbalance;
        string rebalancingAction;
        string emotionalTag;
    }

    KarmaEntry[] public ledger;

    event InfrastructureKarmaRebalanced(string region, string karmaImbalance, string rebalancingAction, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function rebalanceKarma(
        string memory region,
        string memory karmaImbalance,
        string memory rebalancingAction,
        string memory emotionalTag
    ) public onlySteward {
        ledger.push(KarmaEntry(region, karmaImbalance, rebalancingAction, emotionalTag));
        emit InfrastructureKarmaRebalanced(region, karmaImbalance, rebalancingAction, emotionalTag);
    }
}

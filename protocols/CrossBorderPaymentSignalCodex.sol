// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CrossBorderPaymentSignalCodex {
    address public steward;

    struct PaymentSignal {
        string region;
        string useCase;
        string adoptionMetric;
        string emotionalTag;
    }

    PaymentSignal[] public codex;

    event CrossBorderPaymentTagged(string region, string useCase, string adoptionMetric, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagPaymentSignal(
        string memory region,
        string memory useCase,
        string memory adoptionMetric,
        string memory emotionalTag
    ) public onlySteward {
        codex.push(PaymentSignal(region, useCase, adoptionMetric, emotionalTag));
        emit CrossBorderPaymentTagged(region, useCase, adoptionMetric, emotionalTag);
    }
}

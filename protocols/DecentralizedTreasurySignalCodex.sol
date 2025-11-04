// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DecentralizedTreasurySignalCodex {
    address public steward;

    struct TreasurySignal {
        string organization;
        string treasuryUseCase;
        string decentralizationMetric;
        string emotionalTag;
    }

    TreasurySignal[] public codex;

    event TreasurySignalTagged(string organization, string treasuryUseCase, string decentralizationMetric, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagTreasurySignal(
        string memory organization,
        string memory treasuryUseCase,
        string memory decentralizationMetric,
        string memory emotionalTag
    ) public onlySteward {
        codex.push(TreasurySignal(organization, treasuryUseCase, decentralizationMetric, emotionalTag));
        emit TreasurySignalTagged(organization, treasuryUseCase, decentralizationMetric, emotionalTag);
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract LightningTreasuryIntegrationDAO {
    address public steward;

    struct IntegrationEntry {
        string organization;
        string treasuryUseCase;
        string LNIntegrationSignal;
        string emotionalTag;
    }

    IntegrationEntry[] public registry;

    event LightningTreasuryIntegrated(string organization, string treasuryUseCase, string LNIntegrationSignal, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagIntegration(
        string memory organization,
        string memory treasuryUseCase,
        string memory LNIntegrationSignal,
        string memory emotionalTag
    ) public onlySteward {
        registry.push(IntegrationEntry(organization, treasuryUseCase, LNIntegrationSignal, emotionalTag));
        emit LightningTreasuryIntegrated(organization, treasuryUseCase, LNIntegrationSignal, emotionalTag);
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MarketSentimentResilienceDAO {
    address public steward;

    struct SentimentEntry {
        string marketSector;
        string shockType;
        string resilienceSignal;
        string emotionalTag;
    }

    SentimentEntry[] public registry;

    event MarketSentimentTagged(string marketSector, string shockType, string resilienceSignal, string emotionalTag);

    constructor() {
        steward = msg.sender;
    }

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized");
        _;
    }

    function tagSentiment(
        string memory marketSector,
        string memory shockType,
        string memory resilienceSignal,
        string memory emotionalTag
    ) public onlySteward {
        registry.push(SentimentEntry(marketSector, shockType, resilienceSignal, emotionalTag));
        emit MarketSentimentTagged(marketSector, shockType, resilienceSignal, emotionalTag);
    }
}

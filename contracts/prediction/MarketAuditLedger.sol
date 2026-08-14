// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MarketAuditLedger {
    struct Trade {
        bytes32 marketId;
        address trader;
        uint256 amount;
        uint256 outcome;
        uint256 timestamp;
        bytes32 tradeHash;
    }

    struct MarketOutcome {
        bytes32 marketId;
        uint256 outcome;
        bool isFinalized;
        uint256 finalizedAt;
    }

    mapping(bytes32 => Trade[]) public marketTrades;
    mapping(bytes32 => MarketOutcome) public marketOutcomes;
    bytes32[] public marketIds;

    event TradeLogged(bytes32 indexed marketId, address indexed trader, uint256 amount, uint256 outcome);
    event MarketFinalized(bytes32 indexed marketId, uint256 outcome);

    function logTrade(
        bytes32 _marketId,
        address _trader,
        uint256 _amount,
        uint256 _outcome,
        bytes32 _tradeHash
    ) external {
        marketTrades[_marketId].push(Trade({
            marketId: _marketId,
            trader: _trader,
            amount: _amount,
            outcome: _outcome,
            timestamp: block.timestamp,
            tradeHash: _tradeHash
        }));
        emit TradeLogged(_marketId, _trader, _amount, _outcome);
    }

    function finalizeMarket(bytes32 _marketId, uint256 _outcome) external {
        require(!marketOutcomes[_marketId].isFinalized, "Market already finalized");
        marketOutcomes[_marketId] = MarketOutcome({
            marketId: _marketId,
            outcome: _outcome,
            isFinalized: true,
            finalizedAt: block.timestamp
        });
        marketIds.push(_marketId);
        emit MarketFinalized(_marketId, _outcome);
    }

    function getTrades(bytes32 _marketId) external view returns (Trade[] memory) {
        return marketTrades[_marketId];
    }
}

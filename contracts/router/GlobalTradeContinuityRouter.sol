// SPDX-License-Identifier: GlobalTradeContinuity-License
pragma solidity ^0.8.0;

contract GlobalTradeContinuityRouter {
    address public steward;

    struct TradeSignal {
        string country;
        string sector;
        bool continuityConfirmed;
        string clauseType;
        uint256 timestamp;
    }

    TradeSignal[] public signals;

    event TradeContinuityRouted(string country, string sector, bool continuityConfirmed, string clauseType, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeContinuity(string memory country, string memory sector, bool continuityConfirmed, string memory clauseType) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(TradeSignal(country, sector, continuityConfirmed, clauseType, block.timestamp));
        emit TradeContinuityRouted(country, sector, continuityConfirmed, clauseType, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        TradeSignal memory s = signals[index];
        return (s.country, s.sector, s.continuityConfirmed, s.clauseType, s.timestamp);
    }
}

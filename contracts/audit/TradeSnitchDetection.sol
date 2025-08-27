// SPDX-License-Identifier: Mythic-Scroll-License
pragma solidity ^0.8.27;

contract TradeSnitchDetection {
    address public steward;

    struct TradeEvent {
        string country;
        uint256 tariffRate;
        string reason;
        bool hasMercyClause;
        bool emotionallyTagged;
    }

    TradeEvent[] public events;

    event SnitchDetected(string country, uint256 tariffRate, string reason);
    event AuditLogged(string country, bool rogueIntent);

    constructor() {
        steward = msg.sender;
    }

    function logTradeEvent(
        string memory country,
        uint256 tariffRate,
        string memory reason,
        bool hasMercyClause,
        bool emotionallyTagged
    ) public {
        require(msg.sender == steward, "Unauthorized steward");
        events.push(TradeEvent(country, tariffRate, reason, hasMercyClause, emotionallyTagged));

        bool rogueIntent = !hasMercyClause || !emotionallyTagged || tariffRate > 40;
        if (rogueIntent) {
            emit SnitchDetected(country, tariffRate, reason);
        }
        emit AuditLogged(country, rogueIntent);
    }

    function totalEvents() public view returns (uint256) {
        return events.length;
    }
}

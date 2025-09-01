// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract IPTradeLedger {
    struct TradeEntry {
        string tribe;
        string product; // e.g. "Rattan", "Banig", "Mineral Rights", "Coffee"
        uint256 quantity;
        uint256 totalValue;
        string buyer; // e.g. "LGU", "DA", "Mining Firm", "Private Coop"
        uint256 royaltyPercent;
        uint256 royaltyPaid;
        string emotionalTag; // e.g. "AncestorGlow", "AuditGlow", "BlessedFlow"
        uint256 timestamp;
    }

    TradeEntry[] public trades;

    event TradeLogged(string tribe, string product, uint256 totalValue, string buyer, uint256 royaltyPaid, string emotionalTag);

    function logTrade(
        string memory _tribe,
        string memory _product,
        uint256 _quantity,
        uint256 _totalValue,
        string memory _buyer,
        uint256 _royaltyPercent,
        uint256 _royaltyPaid,
        string memory _emotionalTag
    ) public {
        trades.push(TradeEntry(_tribe, _product, _quantity, _totalValue, _buyer, _royaltyPercent, _royaltyPaid, _emotionalTag, block.timestamp));
        emit TradeLogged(_tribe, _product, _totalValue, _buyer, _royaltyPaid, _emotionalTag);
    }

    function getTrade(uint256 index) public view returns (TradeEntry memory) {
        return trades[index];
    }

    function totalTrades() public view returns (uint256) {
        return trades.length;
    }
}

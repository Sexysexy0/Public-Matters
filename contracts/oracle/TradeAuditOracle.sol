// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract TradeAuditOracle {
    struct TradeRecord {
        address vendor;
        address buyer;
        string productTag;
        uint256 amount;
        uint256 tariffRate;
        uint256 emotionalAPR;
        bool audited;
    }

    TradeRecord[] public trades;
    uint256 public auditTaxRate = 1; // 1% civic tax

    event TradeAudited(
        address indexed vendor,
        address indexed buyer,
        string productTag,
        uint256 amount,
        uint256 tariffRate,
        uint256 emotionalAPR,
        uint256 auditTax
    );

    function recordTrade(
        address _vendor,
        address _buyer,
        string memory _productTag,
        uint256 _amount,
        uint256 _tariffRate,
        uint256 _empathy,
        uint256 _trust,
        uint256 _clarity
    ) public {
        uint256 apr = _empathy + _trust + _clarity;
        uint256 auditTax = (_amount * auditTaxRate) / 100;

        trades.push(TradeRecord(_vendor, _buyer, _productTag, _amount, _tariffRate, apr, true));
        emit TradeAudited(_vendor, _buyer, _productTag, _amount, _tariffRate, apr, auditTax);
    }

    function getAllTrades() public view returns (TradeRecord[] memory) {
        return trades;
    }

    function getTradeCount() public view returns (uint256) {
        return trades.length;
    }
}

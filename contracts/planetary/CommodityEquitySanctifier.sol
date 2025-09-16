// SPDX-License-Identifier: CommodityEquitySanctum
pragma solidity ^0.8.19;

contract CommodityEquitySanctifier {
    struct EquitySignal {
        string commodityCode;
        string region;
        uint256 tariffRate;
        bool equityBlessed;
        string stewardNote;
    }

    mapping(string => EquitySignal) public equityRegistry;

    event CommodityTagged(string commodityCode, string region);
    event EquityBlessed(string commodityCode);

    function tagCommodity(string memory commodityCode, string memory region, uint256 tariffRate, string memory stewardNote) public {
        equityRegistry[commodityCode] = EquitySignal(commodityCode, region, tariffRate, false, stewardNote);
        emit CommodityTagged(commodityCode, region);
    }

    function blessEquity(string memory commodityCode) public {
        require(equityRegistry[commodityCode].tariffRate >= 0, "Commodity not tagged");
        equityRegistry[commodityCode].equityBlessed = true;
        emit EquityBlessed(commodityCode);
    }

    function getEquityStatus(string memory commodityCode) public view returns (EquitySignal memory) {
        return equityRegistry[commodityCode];
    }
}

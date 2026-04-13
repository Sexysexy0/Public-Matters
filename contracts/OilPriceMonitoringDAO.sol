// OilPriceMonitoringDAO.sol
pragma solidity ^0.8.0;

contract OilPriceMonitoringDAO {
    struct PriceReport {
        uint256 price;
        uint256 timestamp;
        address reporter;
        bool isFlagged;
    }

    mapping(string => PriceReport[]) public regionalPrices;

    function reportPrice(string memory _lgu, uint256 _pumpPrice) public {
        regionalPrices[_lgu].push(PriceReport(_pumpPrice, block.timestamp, msg.sender, false));
    }

    function auditRegionalPrice(string memory _lgu, uint256 _globalTrend) public {
        // Logic: If pump price is > 15% of global trend, flag for profiteering
        for(uint i=0; i < regionalPrices[_lgu].length; i++) {
            if(regionalPrices[_lgu][i].price > _globalTrend + 15) {
                regionalPrices[_lgu][i].isFlagged = true;
            }
        }
    }
}

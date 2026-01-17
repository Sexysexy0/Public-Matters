pragma solidity ^0.8.20;

contract TokenizationProtocol {
    address public admin;

    struct Market {
        string assetClass;   // e.g. equities, commodities, prediction markets
        string benefit;      // e.g. 24/7 trading, global demand, no settlement risk
        uint256 timestamp;
    }

    Market[] public markets;

    event MarketLogged(string assetClass, string benefit, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logMarket(string calldata assetClass, string calldata benefit) external onlyAdmin {
        markets.push(Market(assetClass, benefit, block.timestamp));
        emit MarketLogged(assetClass, benefit, block.timestamp);
    }

    function totalMarkets() external view returns (uint256) {
        return markets.length;
    }
}

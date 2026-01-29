pragma solidity ^0.8.20;

contract GlobalLiquidityProtocol {
    address public admin;

    struct Liquidity {
        string market;       // e.g. Crypto, Gold, Stocks
        uint256 volume;      // symbolic liquidity value
        string trend;        // e.g. Expansion, Contraction
        uint256 timestamp;
    }

    Liquidity[] public liquidities;

    event LiquidityLogged(string market, uint256 volume, string trend, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logLiquidity(string calldata market, uint256 volume, string calldata trend) external onlyAdmin {
        liquidities.push(Liquidity(market, volume, trend, block.timestamp));
        emit LiquidityLogged(market, volume, trend, block.timestamp);
    }

    function totalLiquidities() external view returns (uint256) {
        return liquidities.length;
    }
}

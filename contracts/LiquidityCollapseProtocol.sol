pragma solidity ^0.8.20;

contract LiquidityCollapseProtocol {
    address public admin;

    struct Liquidity {
        string market;       // e.g. spot, derivatives
        string change;       // e.g. -34.4%, -47.8%
        string impact;       // e.g. thin depth, amplified selling
        uint256 timestamp;
    }

    Liquidity[] public liquidities;

    event LiquidityLogged(string market, string change, string impact, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logLiquidity(string calldata market, string calldata change, string calldata impact) external onlyAdmin {
        liquidities.push(Liquidity(market, change, impact, block.timestamp));
        emit LiquidityLogged(market, change, impact, block.timestamp);
    }

    function totalLiquidities() external view returns (uint256) {
        return liquidities.length;
    }
}

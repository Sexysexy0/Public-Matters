pragma solidity ^0.8.20;

contract InflationHedgeProtocol {
    address public admin;

    struct Hedge {
        string asset;        // e.g. Bitcoin, gold, commodities
        string strategy;     // e.g. long-term hold, ETF, reserve allocation
        string effect;       // e.g. preserve value, resist fiat erosion
        uint256 timestamp;
    }

    Hedge[] public hedges;

    event HedgeLogged(string asset, string strategy, string effect, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logHedge(string calldata asset, string calldata strategy, string calldata effect) external onlyAdmin {
        hedges.push(Hedge(asset, strategy, effect, block.timestamp));
        emit HedgeLogged(asset, strategy, effect, block.timestamp);
    }

    function totalHedges() external view returns (uint256) {
        return hedges.length;
    }
}

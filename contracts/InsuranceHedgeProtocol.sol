pragma solidity ^0.8.20;

contract InsuranceHedgeProtocol {
    address public admin;

    struct Hedge {
        string asset;        // e.g. Bitcoin
        string strategy;     // e.g. options hedge, insurance purchase
        uint256 level;       // e.g. 75000 strike level
        uint256 timestamp;
    }

    Hedge[] public hedges;

    event HedgeLogged(string asset, string strategy, uint256 level, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logHedge(string calldata asset, string calldata strategy, uint256 level) external onlyAdmin {
        hedges.push(Hedge(asset, strategy, level, block.timestamp));
        emit HedgeLogged(asset, strategy, level, block.timestamp);
    }

    function totalHedges() external view returns (uint256) {
        return hedges.length;
    }
}

pragma solidity ^0.8.20;

contract MarketFearProtocol {
    address public admin;

    struct Fear {
        string index;        // e.g. Crypto Fear & Greed Index
        uint256 level;       // e.g. 24 (Extreme Fear)
        string sentiment;    // e.g. panic selling, cautious accumulation
        uint256 timestamp;
    }

    Fear[] public fears;

    event FearLogged(string index, uint256 level, string sentiment, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logFear(string calldata index, uint256 level, string calldata sentiment) external onlyAdmin {
        fears.push(Fear(index, level, sentiment, block.timestamp));
        emit FearLogged(index, level, sentiment, block.timestamp);
    }

    function totalFears() external view returns (uint256) {
        return fears.length;
    }
}

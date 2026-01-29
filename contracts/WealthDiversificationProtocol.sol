pragma solidity ^0.8.20;

contract WealthDiversificationProtocol {
    address public admin;

    struct Diversification {
        string category;      // e.g. Crypto, Gold, Stocks
        uint256 allocation;   // percentage allocation
        string strategy;      // e.g. Balanced, Aggressive
        uint256 timestamp;
    }

    Diversification[] public diversifications;

    event DiversificationLogged(string category, uint256 allocation, string strategy, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logDiversification(string calldata category, uint256 allocation, string calldata strategy) external onlyAdmin {
        diversifications.push(Diversification(category, allocation, strategy, block.timestamp));
        emit DiversificationLogged(category, allocation, strategy, block.timestamp);
    }

    function totalDiversifications() external view returns (uint256) {
        return diversifications.length;
    }
}

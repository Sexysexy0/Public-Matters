pragma solidity ^0.8.20;

contract BreakthroughHarvestProtocol {
    address public admin;

    struct Breakthrough {
        string domain;       // e.g. Business, Finance, Family
        string prophecy;     // e.g. "Massive unfolding"
        uint256 timestamp;
    }

    Breakthrough[] public breakthroughs;

    event BreakthroughLogged(string domain, string prophecy, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logBreakthrough(string calldata domain, string calldata prophecy) external onlyAdmin {
        breakthroughs.push(Breakthrough(domain, prophecy, block.timestamp));
        emit BreakthroughLogged(domain, prophecy, block.timestamp);
    }

    function totalBreakthroughs() external view returns (uint256) {
        return breakthroughs.length;
    }
}

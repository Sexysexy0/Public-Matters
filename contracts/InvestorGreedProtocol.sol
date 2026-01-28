pragma solidity ^0.8.20;

contract InvestorGreedProtocol {
    address public admin;

    struct Greed {
        string source;       // e.g. venture capital, hedge fund
        string behavior;     // e.g. hype chasing, overvaluation
        string consequence;  // e.g. bubble, collapse
        uint256 timestamp;
    }

    Greed[] public greeds;

    event GreedLogged(string source, string behavior, string consequence, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logGreed(string calldata source, string calldata behavior, string calldata consequence) external onlyAdmin {
        greeds.push(Greed(source, behavior, consequence, block.timestamp));
        emit GreedLogged(source, behavior, consequence, block.timestamp);
    }

    function totalGreeds() external view returns (uint256) {
        return greeds.length;
    }
}

pragma solidity ^0.8.20;

contract MarketStabilityProtocol {
    address public admin;

    struct Stability {
        string driver;       // e.g. fuel subsidy, tax adjustment
        string risk;         // e.g. revenue loss, volatility
        string outcome;      // e.g. stable prices, controlled inflation
        uint256 timestamp;
    }

    Stability[] public stabilities;

    event StabilityLogged(string driver, string risk, string outcome, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logStability(string calldata driver, string calldata risk, string calldata outcome) external onlyAdmin {
        stabilities.push(Stability(driver, risk, outcome, block.timestamp));
        emit StabilityLogged(driver, risk, outcome, block.timestamp);
    }

    function totalStabilities() external view returns (uint256) {
        return stabilities.length;
    }
}

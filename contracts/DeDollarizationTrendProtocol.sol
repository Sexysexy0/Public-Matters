pragma solidity ^0.8.20;

contract DeDollarizationTrendProtocol {
    address public admin;

    struct Trend {
        string driver;       // e.g. Bitcoin adoption, gold preference, geopolitical shifts
        string effect;       // e.g. reduced USD dominance, alternative reserves
        uint256 timestamp;
    }

    Trend[] public trends;

    event TrendLogged(string driver, string effect, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logTrend(string calldata driver, string calldata effect) external onlyAdmin {
        trends.push(Trend(driver, effect, block.timestamp));
        emit TrendLogged(driver, effect, block.timestamp);
    }

    function totalTrends() external view returns (uint256) {
        return trends.length;
    }
}

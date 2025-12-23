// contracts/EconoResilience.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title EconoResilience
 * @notice Logs growth forecasts, risks, and communal safeguards for the Philippine economy.
 */
contract EconoResilience {
    address public admin;

    struct Forecast {
        string year;
        uint256 targetGrowth;
        uint256 actualGrowth;
        string verdict;   // "Met", "Missed"
        uint256 timestamp;
    }

    Forecast[] public forecasts;

    event ForecastLogged(string year, uint256 targetGrowth, uint256 actualGrowth, string verdict, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logForecast(string calldata year, uint256 targetGrowth, uint256 actualGrowth, string calldata verdict) external onlyAdmin {
        forecasts.push(Forecast(year, targetGrowth, actualGrowth, verdict, block.timestamp));
        emit ForecastLogged(year, targetGrowth, actualGrowth, verdict, block.timestamp);
    }

    function totalForecasts() external view returns (uint256) { return forecasts.length; }

    function getForecast(uint256 id) external view returns (Forecast memory) {
        require(id < forecasts.length, "Invalid id");
        return forecasts[id];
    }
}

// contracts/PredictionAudit.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title PredictionAudit
 * @notice Logs institutional Bitcoin price predictions vs actual outcomes.
 */
contract PredictionAudit {
    address public admin;

    struct Forecast {
        string institution;
        uint256 predictedPrice;
        uint256 actualPrice;
        string verdict;   // "Achieved", "Missed"
        uint256 timestamp;
    }

    Forecast[] public forecasts;

    event ForecastLogged(string institution, uint256 predictedPrice, uint256 actualPrice, string verdict, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logForecast(string calldata institution, uint256 predictedPrice, uint256 actualPrice, string calldata verdict) external onlyAdmin {
        forecasts.push(Forecast(institution, predictedPrice, actualPrice, verdict, block.timestamp));
        emit ForecastLogged(institution, predictedPrice, actualPrice, verdict, block.timestamp);
    }

    function totalForecasts() external view returns (uint256) { return forecasts.length; }

    function getForecast(uint256 id) external view returns (Forecast memory) {
        require(id < forecasts.length, "Invalid id");
        return forecasts[id];
    }
}

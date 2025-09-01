// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract AuditOracle {
    struct Forecast {
        string region;
        uint256 predictedAuditSurge; // number of audits expected
        uint256 emotionalSpikeIndex; // 0–100
        string causeTag; // e.g. "GriefScroll", "JoySurge", "MediaFeed"
        uint256 timestamp;
    }

    Forecast[] public forecasts;
    address public oracleCaster;

    event ForecastLogged(string region, string causeTag, uint256 predictedAuditSurge, uint256 emotionalSpikeIndex);

    modifier onlyOracleCaster() {
        require(msg.sender == oracleCaster, "Unauthorized oracle caster");
        _;
    }

    constructor() {
        oracleCaster = msg.sender;
    }

    function logForecast(
        string memory _region,
        uint256 _predictedAuditSurge,
        uint256 _emotionalSpikeIndex,
        string memory _causeTag
    ) external onlyOracleCaster {
        forecasts.push(Forecast(_region, _predictedAuditSurge, _emotionalSpikeIndex, _causeTag, block.timestamp));
        emit ForecastLogged(_region, _causeTag, _predictedAuditSurge, _emotionalSpikeIndex);
    }

    function getForecast(uint256 _id) external view returns (Forecast memory) {
        return forecasts[_id];
    }

    function totalForecasts() external view returns (uint256) {
        return forecasts.length;
    }
}

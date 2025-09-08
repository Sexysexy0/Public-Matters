// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketCongressionalCannabisPulseOracle {
    address public steward;
    uint public passageThreshold = 70;

    event BillForecastLogged(string billName, uint supportScore, string forecastStatus, uint timestamp);

    function logForecast(string memory billName, uint supportScore) public {
        string memory status = supportScore >= passageThreshold
            ? "✅ Likely to Pass"
            : "⚠️ At Risk";
        emit BillForecastLogged(billName, supportScore, status, block.timestamp);
    }

    function updateThreshold(uint newThreshold) public {
        require(msg.sender == steward, "Only steward may update threshold");
        passageThreshold = newThreshold;
    }
}

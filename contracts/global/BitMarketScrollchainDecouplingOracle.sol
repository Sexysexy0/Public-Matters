// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketScrollchainDecouplingOracle {
    address public steward;
    uint public entanglementThreshold = 70;

    event DecouplingForecastLogged(string countryPair, uint riskScore, string forecastStatus, uint timestamp);

    function logForecast(string memory countryPair, uint riskScore) public {
        string memory status = riskScore >= entanglementThreshold
            ? "🔥 Decoupling Recommended"
            : "⚠️ Monitoring Phase";
        emit DecouplingForecastLogged(countryPair, riskScore, status, block.timestamp);
    }

    function updateThreshold(uint newThreshold) public {
        require(msg.sender == steward, "Only steward may update threshold");
        entanglementThreshold = newThreshold;
    }
}

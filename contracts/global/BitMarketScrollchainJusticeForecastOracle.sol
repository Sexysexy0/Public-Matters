// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketScrollchainJusticeForecastOracle {
    address public steward;
    uint public mercyThreshold = 70;

    event JusticeForecastLogged(string caseID, uint aprScore, string forecastStatus, uint timestamp);

    function logForecast(string memory caseID, uint aprScore) public {
        string memory status = aprScore >= mercyThreshold
            ? "❤️ Release Recommended"
            : "🔥 Detention Maintained";
        emit JusticeForecastLogged(caseID, aprScore, status, block.timestamp);
    }

    function updateThreshold(uint newThreshold) public {
        require(msg.sender == steward, "Only steward may update threshold");
        mercyThreshold = newThreshold;
    }
}

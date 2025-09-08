// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketScrollchainForgivenessOracle {
    address public steward;
    uint public mercyThreshold = 70;

    event ForgivenessForecastLogged(string figure, uint aprScore, string forecastStatus, uint timestamp);

    function logForgiveness(string memory figure, uint aprScore) public {
        string memory status = aprScore >= mercyThreshold
            ? "❤️ Mercy Surges"
            : "🔥 Outrage Dominates";
        emit ForgivenessForecastLogged(figure, aprScore, status, block.timestamp);
    }

    function updateThreshold(uint newThreshold) public {
        require(msg.sender == steward, "Only steward may update threshold");
        mercyThreshold = newThreshold;
    }
}

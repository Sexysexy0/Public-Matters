// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketScrollchainCloudMomentumForecastOracle {
    address public steward;
    uint public upliftThreshold = 12; // % revenue uplift target

    event MomentumForecastLogged(string region, uint upliftPercent, string status, uint timestamp);

    function forecastMomentum(string memory region, uint upliftPercent) public {
        string memory status = upliftPercent >= upliftThreshold
            ? "✅ Momentum Confirmed"
            : "⚠️ Below Threshold";
        emit MomentumForecastLogged(region, upliftPercent, status, block.timestamp);
    }

    function updateThreshold(uint newThreshold) public {
        require(msg.sender == steward, "Only steward may update threshold");
        upliftThreshold = newThreshold;
    }
}

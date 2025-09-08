// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketStealthScrapingDetectionOracle {
    address public steward;
    uint public cloakThreshold = 70;

    event CloakedActivityLogged(string originCountry, uint stealthScore, string status, uint timestamp);

    function logStealth(string memory originCountry, uint stealthScore) public {
        string memory status = stealthScore >= cloakThreshold
            ? "🔥 Cloaked Route Detected"
            : "✅ Clean Channel";
        emit CloakedActivityLogged(originCountry, stealthScore, status, block.timestamp);
    }

    function updateThreshold(uint newThreshold) public {
        require(msg.sender == steward, "Only steward may update threshold");
        cloakThreshold = newThreshold;
    }
}

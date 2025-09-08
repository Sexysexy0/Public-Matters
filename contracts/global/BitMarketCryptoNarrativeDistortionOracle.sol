// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketCryptoNarrativeDistortionOracle {
    address public steward;
    uint public distortionThreshold = 65;

    event NarrativeDistortionLogged(string headline, uint aprScore, string status, uint timestamp);

    function logDistortion(string memory headline, uint aprScore) public {
        string memory status = aprScore >= distortionThreshold
            ? "🔥 Distortion Detected"
            : "✅ Sentiment Stable";
        emit NarrativeDistortionLogged(headline, aprScore, status, block.timestamp);
    }

    function updateThreshold(uint newThreshold) public {
        require(msg.sender == steward, "Only steward may update threshold");
        distortionThreshold = newThreshold;
    }
}

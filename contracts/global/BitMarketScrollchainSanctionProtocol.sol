// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketScrollchainSanctionProtocol {
    address public steward;
    uint public sanctionThreshold = 80;

    event SanctionTriggered(string countryPair, uint riskScore, string status, uint timestamp);

    function triggerSanction(string memory countryPair, uint riskScore) public {
        string memory status = riskScore >= sanctionThreshold
            ? "🔥 Sanction Activated"
            : "⚠️ Monitoring Phase";
        emit SanctionTriggered(countryPair, riskScore, status, block.timestamp);
    }

    function updateThreshold(uint newThreshold) public {
        require(msg.sender == steward, "Only steward may update threshold");
        sanctionThreshold = newThreshold;
    }
}

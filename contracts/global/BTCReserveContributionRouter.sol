// SPDX-License-Identifier: SovereignSanctum
pragma solidity ^0.8.19;

contract BTCReserveContributionRouter {
    address public steward;

    struct Contribution {
        string contributor;
        uint256 btcAmount;
        string jurisdiction;
        string reservePurpose; // e.g. "Strategic Hedge", "Diaspora Liquidity", "FX Stabilization"
        bool verified;
        uint256 timestamp;
    }

    Contribution[] public contributions;

    event ContributionLogged(string contributor, uint256 btcAmount, string jurisdiction, string reservePurpose, uint256 timestamp);
    event ContributionVerified(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logContribution(
        string memory contributor,
        uint256 btcAmount,
        string memory jurisdiction,
        string memory reservePurpose
    ) public {
        contributions.push(Contribution(contributor, btcAmount, jurisdiction, reservePurpose, false, block.timestamp));
        emit ContributionLogged(contributor, btcAmount, jurisdiction, reservePurpose, block.timestamp);
    }

    function verifyContribution(uint256 index) public {
        require(index < contributions.length, "Invalid index");
        contributions[index].verified = true;
        emit ContributionVerified(index, msg.sender);
    }

    function getContribution(uint256 index) public view returns (
        string memory, uint256, string memory, string memory, bool, uint256
    ) {
        Contribution memory c = contributions[index];
        return (c.contributor, c.btcAmount, c.jurisdiction, c.reservePurpose, c.verified, c.timestamp);
    }

    function totalContributions() public view returns (uint256) {
        return contributions.length;
    }
}

// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

contract ContributionLedger {
    struct Contribution {
        address contributor;
        string description;
        uint256 timestamp;
    }

    Contribution[] public contributions;

    event ContributionLogged(address contributor, string description);

    function logContribution(string calldata description) external {
        contributions.push(Contribution(msg.sender, description, block.timestamp));
        emit ContributionLogged(msg.sender, description);
    }

    function totalContributions() external view returns (uint256) {
        return contributions.length;
    }
}

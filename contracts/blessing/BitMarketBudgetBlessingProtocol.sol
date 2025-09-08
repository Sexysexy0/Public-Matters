// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketBudgetBlessingProtocol {
    address public steward;
    uint public blessingThreshold = 85;

    event BlessingDeployed(string barangay, string domain, uint aprScore, uint amount);

    constructor() {
        steward = msg.sender;
    }

    function deployBlessing(
        string memory barangay,
        string memory domain,
        uint aprScore,
        uint amount
    ) public {
        require(aprScore >= blessingThreshold, "APR too low for blessing");
        emit BlessingDeployed(barangay, domain, aprScore, amount);
    }

    function updateThreshold(uint newThreshold) public {
        require(msg.sender == steward, "Only steward may update threshold");
        blessingThreshold = newThreshold;
    }
}

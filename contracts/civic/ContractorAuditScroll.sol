// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

contract ContractorAuditScroll {
    struct Contribution {
        string contractorName;
        uint256 amount;
        string candidate;
        bool emotionallyTagged;
    }

    Contribution[] public contributions;
    address public steward;

    event ContributionLogged(string contractorName, string candidate, uint256 amount, bool emotionallyTagged);

    constructor() {
        steward = msg.sender;
    }

    function logContribution(string memory contractorName, string memory candidate, uint256 amount, bool emotionallyTagged) public {
        require(msg.sender == steward, "Only steward may log");
        contributions.push(Contribution(contractorName, amount, candidate, emotionallyTagged));
        emit ContributionLogged(contractorName, candidate, amount, emotionallyTagged);
    }

    function getContribution(uint index) public view returns (Contribution memory) {
        return contributions[index];
    }

    function totalContributions() public view returns (uint) {
        return contributions.length;
    }
}

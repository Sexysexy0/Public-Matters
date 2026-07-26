// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract AIContributionFilter {
    struct Contribution {
        address contributor;
        string description;
        bool isAI;
        bool verifiedByHuman;
    }

    Contribution[] public contributions;

    event ContributionSubmitted(address indexed contributor, bool isAI);
    event ContributionVerified(uint256 indexed id, address verifier);

    function submitContribution(string memory _desc, bool _isAI) public {
        contributions.push(Contribution(msg.sender, _desc, _isAI, false));
        emit ContributionSubmitted(msg.sender, _isAI);
    }

    function verifyContribution(uint256 _id) public {
        require(_id < contributions.length, "Invalid ID");
        contributions[_id].verifiedByHuman = true;
        emit ContributionVerified(_id, msg.sender);
    }

    function getContribution(uint256 _id) public view returns (Contribution memory) {
        require(_id < contributions.length, "Invalid ID");
        return contributions[_id];
    }
}

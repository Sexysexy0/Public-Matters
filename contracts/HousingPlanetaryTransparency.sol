// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title HousingPlanetaryTransparency
/// @notice Covenant contract to make DAO proposals and planetary housing outcomes publicly accessible
contract HousingPlanetaryTransparency {
    address public owner;

    struct Outcome {
        uint256 proposalId;   // linked to HousingDAO proposal
        string title;         // proposal title
        string description;   // proposal description
        uint256 votesFor;
        uint256 votesAgainst;
        bool passed;
        uint256 timestamp;
    }

    Outcome[] public outcomes;

    event OutcomeLogged(uint256 proposalId, string title, string description, uint256 votesFor, uint256 votesAgainst, bool passed, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Log DAO proposal outcome for public planetary transparency
    function logOutcome(uint256 proposalId, string memory title, string memory description, uint256 votesFor, uint256 votesAgainst, bool passed) public onlyOwner {
        Outcome memory newOutcome = Outcome(proposalId, title, description, votesFor, votesAgainst, passed, block.timestamp);
        outcomes.push(newOutcome);
        emit OutcomeLogged(proposalId, title, description, votesFor, votesAgainst, passed, block.timestamp);
    }

    function getOutcome(uint256 index) public view returns (uint256, string memory, string memory, uint256, uint256, bool, uint256) {
        Outcome memory o = outcomes[index];
        return (o.proposalId, o.title, o.description, o.votesFor, o.votesAgainst, o.passed, o.timestamp);
    }

    function getOutcomeCount() public view returns (uint256) {
        return outcomes.length;
    }
}

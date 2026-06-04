// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title PlanetaryTransparency
/// @notice Covenant contract to make planetary DAO outcomes and citizen votes publicly accessible
contract PlanetaryTransparency {
    address public owner;

    struct Outcome {
        uint256 proposalId;  // linked to PlanetaryDAO proposal
        string title;        // proposal title
        uint256 votesFor;
        uint256 votesAgainst;
        bool passed;
        uint256 timestamp;
    }

    Outcome[] public outcomes;

    event OutcomeLogged(uint256 proposalId, string title, uint256 votesFor, uint256 votesAgainst, bool passed, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Log planetary DAO outcome for public transparency
    function logOutcome(uint256 proposalId, string memory title, uint256 votesFor, uint256 votesAgainst, bool passed) public onlyOwner {
        Outcome memory newOutcome = Outcome(proposalId, title, votesFor, votesAgainst, passed, block.timestamp);
        outcomes.push(newOutcome);
        emit OutcomeLogged(proposalId, title, votesFor, votesAgainst, passed, block.timestamp);
    }

    function getOutcome(uint256 index) public view returns (uint256, string memory, uint256, uint256, bool, uint256) {
        Outcome memory o = outcomes[index];
        return (o.proposalId, o.title, o.votesFor, o.votesAgainst, o.passed, o.timestamp);
    }

    function getOutcomeCount() public view returns (uint256) {
        return outcomes.length;
    }
}

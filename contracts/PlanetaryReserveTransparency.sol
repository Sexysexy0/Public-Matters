// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title PlanetaryReserveTransparency
/// @notice Covenant contract to make planetary reserve council decisions and outcomes publicly queryable
contract PlanetaryReserveTransparency {
    address public owner;

    struct CouncilOutcome {
        uint256 decisionId;   // linked to PlanetaryReserveCouncil decision
        string title;         // decision title
        string description;   // decision description
        uint256 votesFor;
        uint256 votesAgainst;
        bool passed;
        uint256 timestamp;
    }

    CouncilOutcome[] public councilOutcomes;

    event CouncilOutcomeLogged(uint256 decisionId, string title, string description, uint256 votesFor, uint256 votesAgainst, bool passed, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Log council decision outcome for public transparency
    function logCouncilOutcome(uint256 decisionId, string memory title, string memory description, uint256 votesFor, uint256 votesAgainst, bool passed) public onlyOwner {
        CouncilOutcome memory newOutcome = CouncilOutcome(decisionId, title, description, votesFor, votesAgainst, passed, block.timestamp);
        councilOutcomes.push(newOutcome);
        emit CouncilOutcomeLogged(decisionId, title, description, votesFor, votesAgainst, passed, block.timestamp);
    }

    function getCouncilOutcome(uint256 index) public view returns (uint256, string memory, string memory, uint256, uint256, bool, uint256) {
        CouncilOutcome memory o = councilOutcomes[index];
        return (o.decisionId, o.title, o.description, o.votesFor, o.votesAgainst, o.passed, o.timestamp);
    }

    function getCouncilOutcomeCount() public view returns (uint256) {
        return councilOutcomes.length;
    }
}

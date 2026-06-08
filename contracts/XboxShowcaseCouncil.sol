// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title XboxShowcaseCouncil
/// @notice Covenant contract to govern showcase transparency outcomes and safeguard logs at council level
contract XboxShowcaseCouncil {
    address public owner;

    struct Decision {
        uint256 outcomeId;    // linked to XboxShowcaseTransparency entry
        string domain;        // e.g. "Hype Management", "Delay Protection", "Nostalgia Preservation"
        string resolution;    // council resolution details
        bool ratified;
        uint256 timestamp;
    }

    Decision[] public decisions;

    event DecisionRatified(uint256 outcomeId, string domain, string resolution, bool ratified, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Ratify a transparency outcome into council governance
    function ratifyDecision(uint256 outcomeId, string memory domain, string memory resolution, bool ratified) public onlyOwner {
        Decision memory newDecision = Decision(outcomeId, domain, resolution, ratified, block.timestamp);
        decisions.push(newDecision);
        emit DecisionRatified(outcomeId, domain, resolution, ratified, block.timestamp);
    }

    function getDecision(uint256 index) public view returns (uint256, string memory, string memory, bool, uint256) {
        Decision memory d = decisions[index];
        return (d.outcomeId, d.domain, d.resolution, d.ratified, d.timestamp);
    }

    function getDecisionCount() public view returns (uint256) {
        return decisions.length;
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title USManufacturingTransparency
/// @notice Covenant contract to make US manufacturing safeguard logs and revival outcomes publicly accessible
contract USManufacturingTransparency {
    address public owner;

    struct Outcome {
        uint256 safeguardId;   // linked to USManufacturingSafeguard entry
        string domain;         // e.g. "Competitiveness", "Resilience", "National Security"
        string description;    // safeguard details
        uint256 priority;
        bool implemented;
        uint256 timestamp;
    }

    Outcome[] public outcomes;

    event OutcomeLogged(uint256 safeguardId, string domain, string description, uint256 priority, bool implemented, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Log safeguard outcome for public manufacturing transparency
    function logOutcome(uint256 safeguardId, string memory domain, string memory description, uint256 priority, bool implemented) public onlyOwner {
        Outcome memory newOutcome = Outcome(safeguardId, domain, description, priority, implemented, block.timestamp);
        outcomes.push(newOutcome);
        emit OutcomeLogged(safeguardId, domain, description, priority, implemented, block.timestamp);
    }

    function getOutcome(uint256 index) public view returns (uint256, string memory, string memory, uint256, bool, uint256) {
        Outcome memory o = outcomes[index];
        return (o.safeguardId, o.domain, o.description, o.priority, o.implemented, o.timestamp);
    }

    function getOutcomeCount() public view returns (uint256) {
        return outcomes.length;
    }
}

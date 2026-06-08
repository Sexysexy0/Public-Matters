// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title DeltaForceAntiCheatTransparency
/// @notice Covenant contract to make Delta Force anti-cheat safeguard logs and enforcement outcomes publicly accessible
contract DeltaForceAntiCheatTransparency {
    address public owner;

    struct Outcome {
        uint256 safeguardId;   // linked to DeltaForceAntiCheatSafeguard entry
        string domain;         // e.g. "Ban Evasion", "Matchmaking Fairness", "Console Stability"
        string description;    // safeguard details
        uint256 severity;
        bool enforced;
        uint256 timestamp;
    }

    Outcome[] public outcomes;

    event OutcomeLogged(uint256 safeguardId, string domain, string description, uint256 severity, bool enforced, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Log anti-cheat safeguard outcome for public transparency
    function logOutcome(uint256 safeguardId, string memory domain, string memory description, uint256 severity, bool enforced) public onlyOwner {
        Outcome memory newOutcome = Outcome(safeguardId, domain, description, severity, enforced, block.timestamp);
        outcomes.push(newOutcome);
        emit OutcomeLogged(safeguardId, domain, description, severity, enforced, block.timestamp);
    }

    function getOutcome(uint256 index) public view returns (uint256, string memory, string memory, uint256, bool, uint256) {
        Outcome memory o = outcomes[index];
        return (o.safeguardId, o.domain, o.description, o.severity, o.enforced, o.timestamp);
    }

    function getOutcomeCount() public view returns (uint256) {
        return outcomes.length;
    }
}

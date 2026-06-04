// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title FastWeightsTransparency
/// @notice Covenant contract to make adaptive synapse logs and ethical safeguard outcomes publicly accessible
contract FastWeightsTransparency {
    address public owner;

    struct Outcome {
        uint256 synapseId;   // linked to FastWeights entry
        string domain;       // e.g. "Adaptive Synapse", "Self-Improving Loop", "Ethical Data"
        string description;  // safeguard details
        uint256 decayRate;
        bool implemented;
        uint256 timestamp;
    }

    Outcome[] public outcomes;

    event OutcomeLogged(uint256 synapseId, string domain, string description, uint256 decayRate, bool implemented, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Log adaptive synapse safeguard outcome for public transparency
    function logOutcome(uint256 synapseId, string memory domain, string memory description, uint256 decayRate, bool implemented) public onlyOwner {
        Outcome memory newOutcome = Outcome(synapseId, domain, description, decayRate, implemented, block.timestamp);
        outcomes.push(newOutcome);
        emit OutcomeLogged(synapseId, domain, description, decayRate, implemented, block.timestamp);
    }

    function getOutcome(uint256 index) public view returns (uint256, string memory, string memory, uint256, bool, uint256) {
        Outcome memory o = outcomes[index];
        return (o.synapseId, o.domain, o.description, o.decayRate, o.implemented, o.timestamp);
    }

    function getOutcomeCount() public view returns (uint256) {
        return outcomes.length;
    }
}

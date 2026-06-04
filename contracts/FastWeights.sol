// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title FastWeights
/// @notice Covenant contract to safeguard adaptive synapses, self-improving loops, and ethical data curation
contract FastWeights {
    address public owner;

    struct Synapse {
        string domain;       // e.g. "Adaptive Synapse", "Self-Improving Loop", "Ethical Data"
        string description;  // safeguard details
        uint256 decayRate;   // placeholder metric for fast weight decay
        uint256 timestamp;
    }

    Synapse[] public synapses;

    event SynapseLogged(string domain, string description, uint256 decayRate, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Log a new fast weight safeguard
    function logSynapse(string memory domain, string memory description, uint256 decayRate) public onlyOwner {
        Synapse memory newSynapse = Synapse(domain, description, decayRate, block.timestamp);
        synapses.push(newSynapse);
        emit SynapseLogged(domain, description, decayRate, block.timestamp);
    }

    function getSynapse(uint256 index) public view returns (string memory, string memory, uint256, uint256) {
        Synapse memory s = synapses[index];
        return (s.domain, s.description, s.decayRate, s.timestamp);
    }

    function getSynapseCount() public view returns (uint256) {
        return synapses.length;
    }
}

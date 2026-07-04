pragma solidity ^0.8.20;

/// @title DiscoveryIterationPact
/// @notice Encodes iterative discovery and sensemaking cycles.
/// @dev Anchors hypothesis generation, verification, and adaptive learning.

contract DiscoveryIterationPact {
    address public overseer;
    uint256 public cycleCount;

    struct DiscoveryCycle {
        uint256 id;
        string principle;   // Discovery, Hypothesis, Iteration
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => DiscoveryCycle> public cycles;
    event DiscoveryCycleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareDiscoveryCycle(string calldata principle, string calldata description) external onlyOverseer {
        cycleCount++;
        cycles[cycleCount] = DiscoveryCycle(cycleCount, principle, description, block.timestamp);
        emit DiscoveryCycleDeclared(cycleCount, principle, description);
    }
}

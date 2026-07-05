pragma solidity ^0.8.20;

/// @title ConsciousnessNetworkCodex
/// @notice Encodes covenant for consciousness networks.
/// @dev Anchors unity, awareness, and safeguard rules.

contract ConsciousnessNetworkCodex {
    address public overseer;
    uint256 public codexCount;

    struct NetworkRule {
        uint256 id;
        string principle;   // Unity, Awareness, Safeguard
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => NetworkRule> public rules;
    event NetworkRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareNetworkRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = NetworkRule(codexCount, principle, description, block.timestamp);
        emit NetworkRuleDeclared(codexCount, principle, description);
    }
}

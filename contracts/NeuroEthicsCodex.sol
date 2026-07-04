pragma solidity ^0.8.20;

/// @title NeuroEthicsCodex
/// @notice Encodes neuroethics safeguards for brain-computer interfaces.
/// @dev Anchors privacy, dignity, and ethical safeguards.

contract NeuroEthicsCodex {
    address public overseer;
    uint256 public codexCount;

    struct NeuroRule {
        uint256 id;
        string principle;   // Privacy, Dignity, Ethics
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => NeuroRule> public rules;
    event NeuroRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareNeuroRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = NeuroRule(codexCount, principle, description, block.timestamp);
        emit NeuroRuleDeclared(codexCount, principle, description);
    }
}

pragma solidity ^0.8.20;

/// @title AdaptiveOntologyCodex
/// @notice Encodes adaptive ontology evolution rules.
/// @dev Anchors ontology updates, evolution, and dynamic classification.

contract AdaptiveOntologyCodex {
    address public overseer;
    uint256 public ontologyCount;

    struct OntologyRule {
        uint256 id;
        string principle;   // Ontology, Adaptation, Evolution
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => OntologyRule> public rules;
    event OntologyRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareOntologyRule(string calldata principle, string calldata description) external onlyOverseer {
        ontologyCount++;
        rules[ontologyCount] = OntologyRule(ontologyCount, principle, description, block.timestamp);
        emit OntologyRuleDeclared(ontologyCount, principle, description);
    }
}

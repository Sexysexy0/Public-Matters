pragma solidity ^0.8.20;

/// @title ActivityOntologyCodex
/// @notice Encodes taxonomy of actions vs activities.
/// @dev Anchors ontology structures for ABI analysis.

contract ActivityOntologyCodex {
    address public overseer;
    uint256 public ontologyCount;

    struct Ontology {
        uint256 id;
        string principle;   // Action, Activity, Event
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => Ontology> public ontologies;
    event OntologyDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareOntology(string calldata principle, string calldata description) external onlyOverseer {
        ontologyCount++;
        ontologies[ontologyCount] = Ontology(ontologyCount, principle, description, block.timestamp);
        emit OntologyDeclared(ontologyCount, principle, description);
    }
}

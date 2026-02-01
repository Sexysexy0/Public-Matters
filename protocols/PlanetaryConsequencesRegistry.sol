// PlanetaryConsequencesRegistry.sol
pragma solidity ^0.8.0;

contract PlanetaryConsequencesRegistry {
    struct Consequence {
        uint256 id;
        string domain;       // e.g. "Climate", "Labor", "Finance", "Culture"
        string description;
        address reporter;
        uint256 timestamp;
    }

    uint256 public consequenceCount;
    mapping(uint256 => Consequence) public consequences;

    event ConsequenceLogged(uint256 id, string domain, string description, address reporter, uint256 timestamp);
    event RegistryDeclared(string message);

    // --- Log planetary consequence ---
    function logConsequence(string memory domain, string memory description) public {
        consequenceCount++;
        consequences[consequenceCount] = Consequence(consequenceCount, domain, description, msg.sender, block.timestamp);
        emit ConsequenceLogged(consequenceCount, domain, description, msg.sender, block.timestamp);
    }

    // --- Declare registry ---
    function declareRegistry() public {
        emit RegistryDeclared("Planetary Consequences Registry: encoding climate, labor, finance, and cultural arcs into communal legend.");
    }
}

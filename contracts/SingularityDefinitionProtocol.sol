pragma solidity ^0.8.20;

contract SingularityDefinitionProtocol {
    address public admin;

    struct Definition {
        string source;       // e.g. Kurzweil, Vinge, IBM
        string meaning;      // e.g. irreversible transformation, event horizon, AI surpassing humans
        uint256 timestamp;
    }

    Definition[] public definitions;

    event DefinitionLogged(string source, string meaning, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logDefinition(string calldata source, string calldata meaning) external onlyAdmin {
        definitions.push(Definition(source, meaning, block.timestamp));
        emit DefinitionLogged(source, meaning, block.timestamp);
    }

    function totalDefinitions() external view returns (uint256) {
        return definitions.length;
    }
}

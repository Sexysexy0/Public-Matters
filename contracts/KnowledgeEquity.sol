// contracts/KnowledgeEquity.sol
pragma solidity ^0.8.20;

/**
 * @title KnowledgeEquity
 * @notice Logs initiatives for equitable access to education.
 */
contract KnowledgeEquity {
    address public admin;

    struct Initiative {
        string group;       // "Students", "Workers", "Freelancers"
        string description;
        uint256 timestamp;
    }

    Initiative[] public initiatives;

    event InitiativeLogged(string group, string description, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }
    constructor() { admin = msg.sender; }

    function logInitiative(string calldata group, string calldata description) external onlyAdmin {
        initiatives.push(Initiative(group, description, block.timestamp));
        emit InitiativeLogged(group, description, block.timestamp);
    }
}

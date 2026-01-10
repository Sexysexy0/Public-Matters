pragma solidity ^0.8.20;

contract IdeaGenesisProtocol {
    address public admin;

    struct Idea {
        string concept;      // e.g. infrastructure, energy, education
        string status;       // e.g. proposed, approved, deployed
        uint256 timestamp;
    }

    Idea[] public ideas;

    event IdeaLogged(string concept, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logIdea(string calldata concept, string calldata status) external onlyAdmin {
        ideas.push(Idea(concept, status, block.timestamp));
        emit IdeaLogged(concept, status, block.timestamp);
    }

    function totalIdeas() external view returns (uint256) {
        return ideas.length;
    }
}

// InnovationProtocol.sol
pragma solidity ^0.8.0;

contract InnovationProtocol {
    struct Idea {
        uint256 id;
        string domain;       // e.g. "Fintech"
        string description;  // e.g. "Blockchain-based remittance"
        bool implemented;
        uint256 timestamp;
    }

    uint256 public ideaCount;
    mapping(uint256 => Idea) public ideas;

    event IdeaImplemented(uint256 id, string domain, string description);

    function implementIdea(string memory domain, string memory description) public {
        ideaCount++;
        ideas[ideaCount] = Idea(ideaCount, domain, description, true, block.timestamp);
        emit IdeaImplemented(ideaCount, domain, description);
    }
}

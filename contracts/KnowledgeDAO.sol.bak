// KnowledgeDAO.sol
pragma solidity ^0.8.0;

contract KnowledgeDAO {
    struct Resource {
        uint256 id;
        string topic;   // e.g. "Blockchain Basics"
        string detail;  // e.g. "Open-source learning module"
        bool published;
    }

    uint256 public resourceCount;
    mapping(uint256 => Resource) public resources;

    event ResourcePublished(uint256 id, string topic, string detail);

    function publishResource(string memory topic, string memory detail) public {
        resourceCount++;
        resources[resourceCount] = Resource(resourceCount, topic, detail, true);
        emit ResourcePublished(resourceCount, topic, detail);
    }
}

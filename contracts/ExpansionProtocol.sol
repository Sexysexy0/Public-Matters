// ExpansionProtocol.sol
pragma solidity ^0.8.0;

contract ExpansionProtocol {
    struct Project {
        uint256 id;
        string domain;       // e.g. "New Market"
        string description;  // e.g. "Expand operations to SE Asia"
        bool launched;
        uint256 timestamp;
    }

    uint256 public projectCount;
    mapping(uint256 => Project) public projects;

    event ProjectLaunched(uint256 id, string domain, string description);

    function launchProject(string memory domain, string memory description) public {
        projectCount++;
        projects[projectCount] = Project(projectCount, domain, description, true, block.timestamp);
        emit ProjectLaunched(projectCount, domain, description);
    }
}

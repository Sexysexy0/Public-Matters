// InfrastructureAccountabilityProtocol.sol
pragma solidity ^0.8.0;

contract InfrastructureAccountabilityProtocol {
    struct Project {
        uint256 id;
        string safeguard;  // e.g. "Ensure safe, inclusive public projects"
        string mechanism;  // e.g. "Independent Infrastructure Audit"
        uint256 timestamp;
    }

    uint256 public projectCount;
    mapping(uint256 => Project) public projects;

    event ProjectLogged(uint256 id, string safeguard, string mechanism);

    function logProject(string memory safeguard, string memory mechanism) public {
        projectCount++;
        projects[projectCount] = Project(projectCount, safeguard, mechanism, block.timestamp);
        emit ProjectLogged(projectCount, safeguard, mechanism);
    }
}

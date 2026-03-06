// CommunityEmpowermentProtocol.sol
pragma solidity ^0.8.0;

contract CommunityEmpowermentProtocol {
    struct Project {
        uint256 id;
        string initiative; // e.g. "Barangay Livelihood Program"
        string safeguard;  // e.g. "Enable grassroots participation in welfare design"
        uint256 timestamp;
    }

    uint256 public projectCount;
    mapping(uint256 => Project) public projects;

    event ProjectLogged(uint256 id, string initiative, string safeguard);

    function logProject(string memory initiative, string memory safeguard) public {
        projectCount++;
        projects[projectCount] = Project(projectCount, initiative, safeguard, block.timestamp);
        emit ProjectLogged(projectCount, initiative, safeguard);
    }
}

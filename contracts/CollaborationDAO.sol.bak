// CollaborationDAO.sol
pragma solidity ^0.8.0;

contract CollaborationDAO {
    struct Project {
        uint256 id;
        string partner;   // e.g. "Tech Startup"
        string detail;    // e.g. "Joint AI research"
        bool active;
    }

    uint256 public projectCount;
    mapping(uint256 => Project) public projects;

    event ProjectFormed(uint256 id, string partner, string detail);
    event ProjectActivated(uint256 id, string partner);

    function formProject(string memory partner, string memory detail) public {
        projectCount++;
        projects[projectCount] = Project(projectCount, partner, detail, false);
        emit ProjectFormed(projectCount, partner, detail);
    }

    function activateProject(uint256 id) public {
        projects[id].active = true;
        emit ProjectActivated(id, projects[id].partner);
    }
}

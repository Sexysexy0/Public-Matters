// ConservationDAO.sol
pragma solidity ^0.8.0;

contract ConservationDAO {
    struct Project {
        uint256 id;
        string sector;    // e.g. "Forests"
        string detail;    // e.g. "Reforestation in mining-affected areas"
        uint256 votesFor;
        uint256 votesAgainst;
        bool ratified;
    }

    uint256 public projectCount;
    mapping(uint256 => Project) public projects;

    event ProjectCreated(uint256 id, string sector, string detail);
    event ProjectVoted(uint256 id, string sector, bool support);
    event ProjectRatified(uint256 id, string sector);
    event ConservationDeclared(string message);

    function createProject(string memory sector, string memory detail) public {
        projectCount++;
        projects[projectCount] = Project(projectCount, sector, detail, 0, 0, false);
        emit ProjectCreated(projectCount, sector, detail);
    }

    function voteProject(uint256 id, bool support) public {
        if (support) {
            projects[id].votesFor++;
        } else {
            projects[id].votesAgainst++;
        }
        emit ProjectVoted(id, projects[id].sector, support);
    }

    function ratifyProject(uint256 id) public {
        Project storage p = projects[id];
        require(!p.ratified, "Already ratified");
        require(p.votesFor > p.votesAgainst, "Not enough support");
        p.ratified = true;
        emit ProjectRatified(p.id, p.sector);
    }

    function declareConservation() public {
        emit ConservationDeclared("Conservation DAO: safeguard arcs encoded into communal consequence.");
    }
}

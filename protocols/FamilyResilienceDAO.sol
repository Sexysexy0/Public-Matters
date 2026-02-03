// FamilyResilienceDAO.sol
pragma solidity ^0.8.0;

contract FamilyResilienceDAO {
    struct Project {
        uint256 id;
        string focus;   // e.g. "Supply Chain Stability", "Talent Retention"
        uint256 votesFor;
        uint256 votesAgainst;
        bool enacted;
    }

    uint256 public projectCount;
    mapping(uint256 => Project) public projects;

    event ProjectCreated(uint256 id, string focus);
    event ProjectVoted(uint256 id, string focus, bool support);
    event ProjectEnacted(uint256 id, string focus);
    event ResilienceDeclared(string message);

    function createProject(string memory focus) public {
        projectCount++;
        projects[projectCount] = Project(projectCount, focus, 0, 0, false);
        emit ProjectCreated(projectCount, focus);
    }

    function voteProject(uint256 id, bool support) public {
        if (support) {
            projects[id].votesFor++;
        } else {
            projects[id].votesAgainst++;
        }
        emit ProjectVoted(id, projects[id].focus, support);
    }

    function enactProject(uint256 id) public {
        Project storage p = projects[id];
        require(!p.enacted, "Already enacted");
        require(p.votesFor > p.votesAgainst, "Not enough support");
        p.enacted = true;
        emit ProjectEnacted(p.id, p.focus);
    }

    function declareResilience() public {
        emit ResilienceDeclared("Family Resilience DAO: survival arcs encoded into communal consequence.");
    }
}

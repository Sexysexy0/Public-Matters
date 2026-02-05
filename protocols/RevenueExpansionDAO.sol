// RevenueExpansionDAO.sol
pragma solidity ^0.8.0;

contract RevenueExpansionDAO {
    struct Project {
        uint256 id;
        string sector;   // e.g. "FinTech", "Green Energy"
        uint256 targetGrowth;
        uint256 votesFor;
        uint256 votesAgainst;
        bool enacted;
    }

    uint256 public projectCount;
    mapping(uint256 => Project) public projects;

    event ProjectCreated(uint256 id, string sector, uint256 targetGrowth);
    event ProjectVoted(uint256 id, string sector, bool support);
    event ProjectEnacted(uint256 id, string sector);
    event RevenueDeclared(string message);

    function createProject(string memory sector, uint256 targetGrowth) public {
        projectCount++;
        projects[projectCount] = Project(projectCount, sector, targetGrowth, 0, 0, false);
        emit ProjectCreated(projectCount, sector, targetGrowth);
    }

    function voteProject(uint256 id, bool support) public {
        if (support) {
            projects[id].votesFor++;
        } else {
            projects[id].votesAgainst++;
        }
        emit ProjectVoted(id, projects[id].sector, support);
    }

    function enactProject(uint256 id) public {
        Project storage p = projects[id];
        require(!p.enacted, "Already enacted");
        require(p.votesFor > p.votesAgainst, "Not enough support");
        p.enacted = true;
        emit ProjectEnacted(p.id, p.sector);
    }

    function declareRevenue() public {
        emit RevenueDeclared("Revenue Expansion DAO: growth arcs encoded into communal consequence.");
    }
}

// GlobalDiversificationDAO.sol
pragma solidity ^0.8.0;

contract GlobalDiversificationDAO {
    struct Project {
        uint256 id;
        string region;   // e.g. "Africa", "Asia-Pacific"
        string sector;   // e.g. "FinTech", "Renewable Energy"
        uint256 votesFor;
        uint256 votesAgainst;
        bool enacted;
    }

    uint256 public projectCount;
    mapping(uint256 => Project) public projects;

    event ProjectCreated(uint256 id, string region, string sector);
    event ProjectVoted(uint256 id, string region, string sector, bool support);
    event ProjectEnacted(uint256 id, string region, string sector);
    event DiversificationDeclared(string message);

    function createProject(string memory region, string memory sector) public {
        projectCount++;
        projects[projectCount] = Project(projectCount, region, sector, 0, 0, false);
        emit ProjectCreated(projectCount, region, sector);
    }

    function voteProject(uint256 id, bool support) public {
        if (support) {
            projects[id].votesFor++;
        } else {
            projects[id].votesAgainst++;
        }
        emit ProjectVoted(id, projects[id].region, projects[id].sector, support);
    }

    function enactProject(uint256 id) public {
        Project storage p = projects[id];
        require(!p.enacted, "Already enacted");
        require(p.votesFor > p.votesAgainst, "Not enough support");
        p.enacted = true;
        emit ProjectEnacted(p.id, p.sector);
    }

    function declareDiversification() public {
        emit DiversificationDeclared("Global Diversification DAO: expansion arcs encoded into communal consequence.");
    }
}

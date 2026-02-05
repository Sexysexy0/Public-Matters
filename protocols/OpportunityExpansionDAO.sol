// OpportunityExpansionDAO.sol
pragma solidity ^0.8.0;

contract OpportunityExpansionDAO {
    struct Project {
        uint256 id;
        string region;   // e.g. "Africa", "Asia-Pacific"
        string focus;    // e.g. "Digital Workforce", "Green Energy"
        uint256 votesFor;
        uint256 votesAgainst;
        bool enacted;
    }

    uint256 public projectCount;
    mapping(uint256 => Project) public projects;

    event ProjectCreated(uint256 id, string region, string focus);
    event ProjectVoted(uint256 id, string region, string focus, bool support);
    event ProjectEnacted(uint256 id, string region, string focus);
    event OpportunityDeclared(string message);

    function createProject(string memory region, string memory focus) public {
        projectCount++;
        projects[projectCount] = Project(projectCount, region, focus, 0, 0, false);
        emit ProjectCreated(projectCount, region, focus);
    }

    function voteProject(uint256 id, bool support) public {
        if (support) {
            projects[id].votesFor++;
        } else {
            projects[id].votesAgainst++;
        }
        emit ProjectVoted(id, projects[id].region, projects[id].focus, support);
    }

    function enactProject(uint256 id) public {
        Project storage p = projects[id];
        require(!p.enacted, "Already enacted");
        require(p.votesFor > p.votesAgainst, "Not enough support");
        p.enacted = true;
        emit ProjectEnacted(p.id, p.focus);
    }

    function declareOpportunity() public {
        emit OpportunityDeclared("Opportunity Expansion DAO: growth arcs encoded into communal consequence.");
    }
}

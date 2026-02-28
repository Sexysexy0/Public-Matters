// OpportunityDAO.sol
pragma solidity ^0.8.0;

contract OpportunityDAO {
    struct Program {
        uint256 id;
        string sector;    // e.g. "Education"
        string detail;    // e.g. "Scholarship for low-income students"
        uint256 votesFor;
        uint256 votesAgainst;
        bool ratified;
    }

    uint256 public programCount;
    mapping(uint256 => Program) public programs;

    event ProgramCreated(uint256 id, string sector, string detail);
    event ProgramVoted(uint256 id, string sector, bool support);
    event ProgramRatified(uint256 id, string sector);
    event OpportunityDeclared(string message);

    function createProgram(string memory sector, string memory detail) public {
        programCount++;
        programs[programCount] = Program(programCount, sector, detail, 0, 0, false);
        emit ProgramCreated(programCount, sector, detail);
    }

    function voteProgram(uint256 id, bool support) public {
        if (support) {
            programs[id].votesFor++;
        } else {
            programs[id].votesAgainst++;
        }
        emit ProgramVoted(id, programs[id].sector, support);
    }

    function ratifyProgram(uint256 id) public {
        Program storage p = programs[id];
        require(!p.ratified, "Already ratified");
        require(p.votesFor > p.votesAgainst, "Not enough support");
        p.ratified = true;
        emit ProgramRatified(p.id, p.sector);
    }

    function declareOpportunity() public {
        emit OpportunityDeclared("Opportunity DAO: safeguard arcs encoded into communal consequence.");
    }
}

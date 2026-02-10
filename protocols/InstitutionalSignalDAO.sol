// InstitutionalSignalDAO.sol
pragma solidity ^0.8.0;

contract InstitutionalSignalDAO {
    struct Institution {
        uint256 id;
        string name;   // e.g. "JPMorgan", "BlackRock"
        string action; // e.g. "Custody", "ETF Launch"
        uint256 votesFor;
        uint256 votesAgainst;
        bool resolved;
    }

    uint256 public institutionCount;
    mapping(uint256 => Institution) public institutions;

    event InstitutionCreated(uint256 id, string name, string action);
    event InstitutionVoted(uint256 id, string name, bool support);
    event InstitutionResolved(uint256 id, string name);
    event InstitutionDeclared(string message);

    function createInstitution(string memory name, string memory action) public {
        institutionCount++;
        institutions[institutionCount] = Institution(institutionCount, name, action, 0, 0, false);
        emit InstitutionCreated(institutionCount, name, action);
    }

    function voteInstitution(uint256 id, bool support) public {
        if (support) {
            institutions[id].votesFor++;
        } else {
            institutions[id].votesAgainst++;
        }
        emit InstitutionVoted(id, institutions[id].name, support);
    }

    function resolveInstitution(uint256 id) public {
        Institution storage i = institutions[id];
        require(!i.resolved, "Already resolved");
        require(i.votesFor > i.votesAgainst, "Not enough support");
        i.resolved = true;
        emit InstitutionResolved(i.id, i.name);
    }

    function declareInstitution() public {
        emit InstitutionDeclared("Institutional Signal DAO: safeguard arcs encoded into communal consequence.");
    }
}

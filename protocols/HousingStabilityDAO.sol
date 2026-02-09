// HousingStabilityDAO.sol
pragma solidity ^0.8.0;

contract HousingStabilityDAO {
    struct Case {
        uint256 id;
        string type;   // e.g. "Variable Mortgage", "Fixed Mortgage"
        string status; // e.g. "Stable", "At Risk"
        uint256 votesFor;
        uint256 votesAgainst;
        bool resolved;
    }

    uint256 public caseCount;
    mapping(uint256 => Case) public cases;

    event CaseCreated(uint256 id, string type, string status);
    event CaseVoted(uint256 id, string type, bool support);
    event CaseResolved(uint256 id, string type);
    event HousingDeclared(string message);

    function createCase(string memory type, string memory status) public {
        caseCount++;
        cases[caseCount] = Case(caseCount, type, status, 0, 0, false);
        emit CaseCreated(caseCount, type, status);
    }

    function voteCase(uint256 id, bool support) public {
        if (support) {
            cases[id].votesFor++;
        } else {
            cases[id].votesAgainst++;
        }
        emit CaseVoted(id, cases[id].type, support);
    }

    function resolveCase(uint256 id) public {
        Case storage c = cases[id];
        require(!c.resolved, "Already resolved");
        require(c.votesFor > c.votesAgainst, "Not enough support");
        c.resolved = true;
        emit CaseResolved(c.id, c.type);
    }

    function declareHousing() public {
        emit HousingDeclared("Housing Stability DAO: safeguard arcs encoded into communal consequence.");
    }
}

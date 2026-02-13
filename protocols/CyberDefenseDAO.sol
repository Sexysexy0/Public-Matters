// CyberDefenseDAO.sol
pragma solidity ^0.8.0;

contract CyberDefenseDAO {
    struct Defense {
        uint256 id;
        string measure;   // e.g. "Rate Limiting", "Account Blocking"
        string status;    // e.g. "Active", "Inactive"
        uint256 votesFor;
        uint256 votesAgainst;
        bool resolved;
    }

    uint256 public defenseCount;
    mapping(uint256 => Defense) public defenses;

    event DefenseCreated(uint256 id, string measure, string status);
    event DefenseVoted(uint256 id, string measure, bool support);
    event DefenseResolved(uint256 id, string measure);
    event CyberDeclared(string message);

    function createDefense(string memory measure, string memory status) public {
        defenseCount++;
        defenses[defenseCount] = Defense(defenseCount, measure, status, 0, 0, false);
        emit DefenseCreated(defenseCount, measure, status);
    }

    function voteDefense(uint256 id, bool support) public {
        if (support) {
            defenses[id].votesFor++;
        } else {
            defenses[id].votesAgainst++;
        }
        emit DefenseVoted(id, defenses[id].measure, support);
    }

    function resolveDefense(uint256 id) public {
        Defense storage d = defenses[id];
        require(!d.resolved, "Already resolved");
        require(d.votesFor > d.votesAgainst, "Not enough support");
        d.resolved = true;
        emit DefenseResolved(d.id, d.measure);
    }

    function declareCyber() public {
        emit CyberDeclared("Cyber Defense DAO: safeguard arcs encoded into communal consequence.");
    }
}

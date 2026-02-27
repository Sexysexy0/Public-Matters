// AppealDAO.sol
pragma solidity ^0.8.0;

contract AppealDAO {
    struct Appeal {
        uint256 id;
        string caseName;   // e.g. "EJK Case"
        string appellant;  // e.g. "Defense Counsel"
        uint256 votesFor;
        uint256 votesAgainst;
        bool ratified;
    }

    uint256 public appealCount;
    mapping(uint256 => Appeal) public appeals;

    event AppealCreated(uint256 id, string caseName, string appellant);
    event AppealVoted(uint256 id, string caseName, bool support);
    event AppealRatified(uint256 id, string caseName);
    event AppealDeclared(string message);

    function createAppeal(string memory caseName, string memory appellant) public {
        appealCount++;
        appeals[appealCount] = Appeal(appealCount, caseName, appellant, 0, 0, false);
        emit AppealCreated(appealCount, caseName, appellant);
    }

    function voteAppeal(uint256 id, bool support) public {
        if (support) {
            appeals[id].votesFor++;
        } else {
            appeals[id].votesAgainst++;
        }
        emit AppealVoted(id, appeals[id].caseName, support);
    }

    function ratifyAppeal(uint256 id) public {
        Appeal storage a = appeals[id];
        require(!a.ratified, "Already ratified");
        require(a.votesFor > a.votesAgainst, "Not enough support");
        a.ratified = true;
        emit AppealRatified(a.id, a.caseName);
    }

    function declareAppeal() public {
        emit AppealDeclared("Appeal DAO: safeguard arcs encoded into communal consequence.");
    }
}

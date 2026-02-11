// CompensationDAO.sol
pragma solidity ^0.8.0;

contract CompensationDAO {
    struct Claim {
        uint256 id;
        string party;   // e.g. "Customer", "Exchange"
        string type;    // e.g. "Refund", "Reimbursement"
        uint256 votesFor;
        uint256 votesAgainst;
        bool resolved;
    }

    uint256 public claimCount;
    mapping(uint256 => Claim) public claims;

    event ClaimCreated(uint256 id, string party, string type);
    event ClaimVoted(uint256 id, string party, bool support);
    event ClaimResolved(uint256 id, string party);
    event CompensationDeclared(string message);

    function createClaim(string memory party, string memory type) public {
        claimCount++;
        claims[claimCount] = Claim(claimCount, party, type, 0, 0, false);
        emit ClaimCreated(claimCount, party, type);
    }

    function voteClaim(uint256 id, bool support) public {
        if (support) {
            claims[id].votesFor++;
        } else {
            claims[id].votesAgainst++;
        }
        emit ClaimVoted(id, claims[id].party, support);
    }

    function resolveClaim(uint256 id) public {
        Claim storage c = claims[id];
        require(!c.resolved, "Already resolved");
        require(c.votesFor > c.votesAgainst, "Not enough support");
        c.resolved = true;
        emit ClaimResolved(c.id, c.party);
    }

    function declareCompensation() public {
        emit CompensationDeclared("Compensation DAO: safeguard arcs encoded into communal consequence.");
    }
}

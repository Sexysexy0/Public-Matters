// RightsDAO.sol
pragma solidity ^0.8.0;

contract RightsDAO {
    struct Claim {
        uint256 id;
        string person;   // e.g. "OFW", "Detained Citizen"
        string right;    // e.g. "Fair Trial", "Freedom from Exploitation"
        uint256 votesFor;
        uint256 votesAgainst;
        bool resolved;
    }

    uint256 public claimCount;
    mapping(uint256 => Claim) public claims;

    event ClaimCreated(uint256 id, string person, string right);
    event ClaimVoted(uint256 id, string person, bool support);
    event ClaimResolved(uint256 id, string person);
    event RightsDeclared(string message);

    function createClaim(string memory person, string memory right) public {
        claimCount++;
        claims[claimCount] = Claim(claimCount, person, right, 0, 0, false);
        emit ClaimCreated(claimCount, person, right);
    }

    function voteClaim(uint256 id, bool support) public {
        if (support) {
            claims[id].votesFor++;
        } else {
            claims[id].votesAgainst++;
        }
        emit ClaimVoted(id, claims[id].person, support);
    }

    function resolveClaim(uint256 id) public {
        Claim storage c = claims[id];
        require(!c.resolved, "Already resolved");
        require(c.votesFor > c.votesAgainst, "Not enough support");
        c.resolved = true;
        emit ClaimResolved(c.id, c.person);
    }

    function declareRights() public {
        emit RightsDeclared("Rights DAO: safeguard arcs encoded into communal consequence.");
    }
}

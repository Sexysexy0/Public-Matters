// PersonhoodDAO.sol
pragma solidity ^0.8.0;

contract PersonhoodDAO {
    struct Claim {
        uint256 id;
        string entity;    // e.g. "AI System"
        string detail;    // e.g. "Requesting legal rights"
        uint256 votesFor;
        uint256 votesAgainst;
        bool ratified;
    }

    uint256 public claimCount;
    mapping(uint256 => Claim) public claims;

    event ClaimCreated(uint256 id, string entity, string detail);
    event ClaimVoted(uint256 id, string entity, bool support);
    event ClaimRatified(uint256 id, string entity);
    event PersonhoodDeclared(string message);

    function createClaim(string memory entity, string memory detail) public {
        claimCount++;
        claims[claimCount] = Claim(claimCount, entity, detail, 0, 0, false);
        emit ClaimCreated(claimCount, entity, detail);
    }

    function voteClaim(uint256 id, bool support) public {
        if (support) {
            claims[id].votesFor++;
        } else {
            claims[id].votesAgainst++;
        }
        emit ClaimVoted(id, claims[id].entity, support);
    }

    function ratifyClaim(uint256 id) public {
        Claim storage c = claims[id];
        require(!c.ratified, "Already ratified");
        require(c.votesFor > c.votesAgainst, "Not enough support");
        c.ratified = true;
        emit ClaimRatified(c.id, c.entity);
    }

    function declarePersonhood() public {
        emit PersonhoodDeclared("Personhood DAO: safeguard arcs encoded into communal consequence.");
    }
}

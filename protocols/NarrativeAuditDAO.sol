// NarrativeAuditDAO.sol
pragma solidity ^0.8.0;

contract NarrativeAuditDAO {
    struct Claim {
        uint256 id;
        string source;   // e.g. "Government Statement", "Media Report"
        string verdict;  // e.g. "True", "False", "Misleading"
        uint256 votesFor;
        uint256 votesAgainst;
        bool published;
    }

    uint256 public claimCount;
    mapping(uint256 => Claim) public claims;

    event ClaimCreated(uint256 id, string source, string verdict);
    event ClaimVoted(uint256 id, string source, bool support);
    event ClaimPublished(uint256 id, string source);
    event AuditDeclared(string message);

    function createClaim(string memory source, string memory verdict) public {
        claimCount++;
        claims[claimCount] = Claim(claimCount, source, verdict, 0, 0, false);
        emit ClaimCreated(claimCount, source, verdict);
    }

    function voteClaim(uint256 id, bool support) public {
        if (support) {
            claims[id].votesFor++;
        } else {
            claims[id].votesAgainst++;
        }
        emit ClaimVoted(id, claims[id].source, support);
    }

    function publishClaim(uint256 id) public {
        Claim storage c = claims[id];
        require(!c.published, "Already published");
        require(c.votesFor > c.votesAgainst, "Not enough support");
        c.published = true;
        emit ClaimPublished(c.id, c.source);
    }

    function declareAudit() public {
        emit AuditDeclared("Narrative Audit DAO: truth arcs encoded into communal consequence.");
    }
}

// TransparencyDAO.sol
pragma solidity ^0.8.0;

contract TransparencyDAO {
    struct Audit {
        uint256 id;
        string institution;   // e.g. "Ministry of Finance", "Public Works"
        string finding;       // e.g. "Transparent", "Opaque"
        uint256 votesFor;
        uint256 votesAgainst;
        bool published;
    }

    uint256 public auditCount;
    mapping(uint256 => Audit) public audits;

    event AuditCreated(uint256 id, string institution, string finding);
    event AuditVoted(uint256 id, string institution, bool support);
    event AuditPublished(uint256 id, string institution);
    event TransparencyDeclared(string message);

    function createAudit(string memory institution, string memory finding) public {
        auditCount++;
        audits[auditCount] = Audit(auditCount, institution, finding, 0, 0, false);
        emit AuditCreated(auditCount, institution, finding);
    }

    function voteAudit(uint256 id, bool support) public {
        if (support) {
            audits[id].votesFor++;
        } else {
            audits[id].votesAgainst++;
        }
        emit AuditVoted(id, audits[id].institution, support);
    }

    function publishAudit(uint256 id) public {
        Audit storage a = audits[id];
        require(!a.published, "Already published");
        require(a.votesFor > a.votesAgainst, "Not enough support");
        a.published = true;
        emit AuditPublished(a.id, a.institution);
    }

    function declareTransparency() public {
        emit TransparencyDeclared("Transparency DAO: safeguard arcs encoded into communal consequence.");
    }
}

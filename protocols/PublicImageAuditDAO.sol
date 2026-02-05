// PublicImageAuditDAO.sol
pragma solidity ^0.8.0;

contract PublicImageAuditDAO {
    struct Audit {
        uint256 id;
        string medium;   // e.g. "Magazine", "Billboard"
        string finding;  // e.g. "Excessive Self-Promotion", "Balanced Tourism Focus"
        uint256 votesFor;
        uint256 votesAgainst;
        bool published;
    }

    uint256 public auditCount;
    mapping(uint256 => Audit) public audits;

    event AuditCreated(uint256 id, string medium, string finding);
    event AuditVoted(uint256 id, string medium, bool support);
    event AuditPublished(uint256 id, string medium);
    event ImageDeclared(string message);

    function createAudit(string memory medium, string memory finding) public {
        auditCount++;
        audits[auditCount] = Audit(auditCount, medium, finding, 0, 0, false);
        emit AuditCreated(auditCount, medium, finding);
    }

    function voteAudit(uint256 id, bool support) public {
        if (support) {
            audits[id].votesFor++;
        } else {
            audits[id].votesAgainst++;
        }
        emit AuditVoted(id, audits[id].medium, support);
    }

    function publishAudit(uint256 id) public {
        Audit storage a = audits[id];
        require(!a.published, "Already published");
        require(a.votesFor > a.votesAgainst, "Not enough support");
        a.published = true;
        emit AuditPublished(a.id, a.medium);
    }

    function declareImage() public {
        emit ImageDeclared("Public Image Audit DAO: transparency arcs encoded into communal consequence.");
    }
}

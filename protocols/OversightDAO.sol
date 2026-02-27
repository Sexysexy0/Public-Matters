// OversightDAO.sol
pragma solidity ^0.8.0;

contract OversightDAO {
    struct Audit {
        uint256 id;
        string subject;   // e.g. "Senate Oversight"
        string detail;    // e.g. "ICC Case Monitoring"
        uint256 votesFor;
        uint256 votesAgainst;
        bool ratified;
    }

    uint256 public auditCount;
    mapping(uint256 => Audit) public audits;

    event AuditCreated(uint256 id, string subject, string detail);
    event AuditVoted(uint256 id, string subject, bool support);
    event AuditRatified(uint256 id, string subject);
    event OversightDeclared(string message);

    function createAudit(string memory subject, string memory detail) public {
        auditCount++;
        audits[auditCount] = Audit(auditCount, subject, detail, 0, 0, false);
        emit AuditCreated(auditCount, subject, detail);
    }

    function voteAudit(uint256 id, bool support) public {
        if (support) {
            audits[id].votesFor++;
        } else {
            audits[id].votesAgainst++;
        }
        emit AuditVoted(id, audits[id].subject, support);
    }

    function ratifyAudit(uint256 id) public {
        Audit storage a = audits[id];
        require(!a.ratified, "Already ratified");
        require(a.votesFor > a.votesAgainst, "Not enough support");
        a.ratified = true;
        emit AuditRatified(a.id, a.subject);
    }

    function declareOversight() public {
        emit OversightDeclared("Oversight DAO: safeguard arcs encoded into communal consequence.");
    }
}

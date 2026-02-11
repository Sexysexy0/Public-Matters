// SupplyChainDAO.sol
pragma solidity ^0.8.0;

contract SupplyChainDAO {
    struct Audit {
        uint256 id;
        string supplier;   // e.g. "PepsiCo"
        string issue;      // e.g. "Price Manipulation", "Favoritism"
        uint256 votesFor;
        uint256 votesAgainst;
        bool resolved;
    }

    uint256 public auditCount;
    mapping(uint256 => Audit) public audits;

    event AuditCreated(uint256 id, string supplier, string issue);
    event AuditVoted(uint256 id, string supplier, bool support);
    event AuditResolved(uint256 id, string supplier);
    event SupplyDeclared(string message);

    function createAudit(string memory supplier, string memory issue) public {
        auditCount++;
        audits[auditCount] = Audit(auditCount, supplier, issue, 0, 0, false);
        emit AuditCreated(auditCount, supplier, issue);
    }

    function voteAudit(uint256 id, bool support) public {
        if (support) {
            audits[id].votesFor++;
        } else {
            audits[id].votesAgainst++;
        }
        emit AuditVoted(id, audits[id].supplier, support);
    }

    function resolveAudit(uint256 id) public {
        Audit storage a = audits[id];
        require(!a.resolved, "Already resolved");
        require(a.votesFor > a.votesAgainst, "Not enough support");
        a.resolved = true;
        emit AuditResolved(a.id, a.supplier);
    }

    function declareSupply() public {
        emit SupplyDeclared("Supply Chain DAO: safeguard arcs encoded into communal consequence.");
    }
}

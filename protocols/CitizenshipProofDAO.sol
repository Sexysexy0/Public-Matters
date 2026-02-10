// CitizenshipProofDAO.sol
pragma solidity ^0.8.0;

contract CitizenshipProofDAO {
    struct Proof {
        uint256 id;
        string document;   // e.g. "Birth Certificate", "Naturalization Papers"
        string status;     // e.g. "Verified", "Pending"
        uint256 votesFor;
        uint256 votesAgainst;
        bool resolved;
    }

    uint256 public proofCount;
    mapping(uint256 => Proof) public proofs;

    event ProofCreated(uint256 id, string document, string status);
    event ProofVoted(uint256 id, string document, bool support);
    event ProofResolved(uint256 id, string document);
    event CitizenshipDeclared(string message);

    function createProof(string memory document, string memory status) public {
        proofCount++;
        proofs[proofCount] = Proof(proofCount, document, status, 0, 0, false);
        emit ProofCreated(proofCount, document, status);
    }

    function voteProof(uint256 id, bool support) public {
        if (support) {
            proofs[id].votesFor++;
        } else {
            proofs[id].votesAgainst++;
        }
        emit ProofVoted(id, proofs[id].document, support);
    }

    function resolveProof(uint256 id) public {
        Proof storage p = proofs[id];
        require(!p.resolved, "Already resolved");
        require(p.votesFor > p.votesAgainst, "Not enough support");
        p.resolved = true;
        emit ProofResolved(p.id, p.document);
    }

    function declareCitizenship() public {
        emit CitizenshipDeclared("Citizenship Proof DAO: safeguard arcs encoded into communal consequence.");
    }
}

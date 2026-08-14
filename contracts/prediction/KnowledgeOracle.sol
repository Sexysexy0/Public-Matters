// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract KnowledgeOracle {
    struct KnowledgeProof {
        bytes32 commitment;
        bytes32 marketId;
        uint256 timestamp;
        address prover;
        bool isVerified;
    }

    mapping(bytes32 => KnowledgeProof) public proofs;
    mapping(address => uint256) public verificationScore;

    event ProofSubmitted(bytes32 indexed proofId, address indexed prover);
    event ProofVerified(bytes32 indexed proofId, address indexed prover);

    function submitKnowledgeProof(
        bytes32 _proofId,
        bytes32 _marketId,
        bytes32 _commitment
    ) external {
        require(proofs[_proofId].prover == address(0), "Proof already exists");
        proofs[_proofId] = KnowledgeProof({
            commitment: _commitment,
            marketId: _marketId,
            timestamp: block.timestamp,
            prover: msg.sender,
            isVerified: false
        });
        emit ProofSubmitted(_proofId, msg.sender);
    }

    function verifyKnowledgeProof(bytes32 _proofId, bytes32 _reveal) external {
        KnowledgeProof storage proof = proofs[_proofId];
        require(proof.prover != address(0), "Proof does not exist");
        require(!proof.isVerified, "Already verified");
        require(keccak256(abi.encodePacked(_reveal)) == proof.commitment, "Invalid reveal");
        proof.isVerified = true;
        verificationScore[proof.prover] += 10;
        emit ProofVerified(_proofId, proof.prover);
    }
}

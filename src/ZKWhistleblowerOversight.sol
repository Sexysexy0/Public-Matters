// SPDX-License-Identifier: MIT
pragma solidity 0.8.35;

/**
 * @title ZKWhistleblowerOversight
 * @notice Provides confidential, Merkle-verified reporting for whistleblowers and intelligence oversight.
 */
contract ZKWhistleblowerOversight {
    address public immutable owner;
    bytes32 public authorizedMerkleRoot;

    struct IntelligenceReport {
        bytes32 evidenceHash;
        uint256 timestamp;
        bool verified;
    }

    mapping(uint256 => IntelligenceReport) public reports;
    uint256 public reportCount;

    event ReportSubmitted(uint256 indexed reportId, bytes32 evidenceHash, uint256 timestamp);
    event MerkleRootUpdated(bytes32 newRoot);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner permitted");
        _;
    }

    constructor(bytes32 _initialMerkleRoot) {
        owner = msg.sender;
        authorizedMerkleRoot = _initialMerkleRoot;
    }

    function setMerkleRoot(bytes32 _newRoot) external onlyOwner {
        authorizedMerkleRoot = _newRoot;
        emit MerkleRootUpdated(_newRoot);
    }

    function verifyProof(bytes32 leaf, bytes32[] calldata proof) public view returns (bool) {
        bytes32 computedHash = leaf;
        for (uint256 i = 0; i < proof.length; i++) {
            bytes32 proofElement = proof[i];
            if (computedHash <= proofElement) {
                computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
            } else {
                computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
            }
        }
        return computedHash == authorizedMerkleRoot;
    }

    function submitAnonymousReport(bytes32 evidenceHash, bytes32 identityCommitment, bytes32[] calldata proof)
        external
        returns (uint256 reportId)
    {
        require(verifyProof(identityCommitment, proof), "Invalid identity proof or clearance");

        reportId = ++reportCount;
        reports[reportId] = IntelligenceReport({evidenceHash: evidenceHash, timestamp: block.timestamp, verified: true});

        emit ReportSubmitted(reportId, evidenceHash, block.timestamp);
    }
}

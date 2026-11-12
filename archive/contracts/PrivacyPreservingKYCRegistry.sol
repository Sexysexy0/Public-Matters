// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "./OperatorPrivileges.sol";

/**
 * @title PrivacyPreservingKYCRegistry
 * @notice KYC attestation via salted hash + ZK proof hash. No raw PII on-chain.
 *         Permissionless appeal path. Operator-gated resolution.
 */
contract PrivacyPreservingKYCRegistry {
    OperatorPrivileges public immutable privileges;

    enum Status { None, Pending, Cleared, Flagged, Revoked }

    struct Attestation {
        bytes32 subjectHash;
        bytes32 zkProofHash;
        Status status;
        uint256 attestedAt;
        address attestedBy;
        string reason;
    }

    mapping(bytes32 => Attestation) public attestations;
    mapping(bytes32 => address[]) public appealsLog;
    mapping(bytes32 => uint256) public appealCount;

    event AttestationRecorded(bytes32 indexed subjectHash, Status status, address indexed attestedBy, uint256 timestamp);
    event AppealFiled(bytes32 indexed subjectHash, address indexed appellant, uint256 timestamp);
    event AppealResolved(bytes32 indexed subjectHash, Status newStatus, address indexed resolvedBy, string reason);

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not authorized operator");
        _;
    }

    constructor(address _privileges) {
        require(_privileges != address(0), "privileges=0");
        privileges = OperatorPrivileges(_privileges);
    }

    function recordAttestation(
        bytes32 _subjectHash,
        bytes32 _zkProofHash,
        Status _status,
        string calldata _reason
    ) external onlyOperator {
        require(_subjectHash != bytes32(0), "Invalid subject hash");
        require(_status != Status.None, "Invalid status");

        attestations[_subjectHash] = Attestation({
            subjectHash: _subjectHash,
            zkProofHash: _zkProofHash,
            status: _status,
            attestedAt: block.timestamp,
            attestedBy: msg.sender,
            reason: _reason
        });

        emit AttestationRecorded(_subjectHash, _status, msg.sender, block.timestamp);
    }

    function appeal(bytes32 _subjectHash) external {
        require(attestations[_subjectHash].subjectHash != bytes32(0), "No attestation found");
        appealsLog[_subjectHash].push(msg.sender);
        appealCount[_subjectHash]++;
        emit AppealFiled(_subjectHash, msg.sender, block.timestamp);
    }

    function resolveAppeal(
        bytes32 _subjectHash,
        Status _newStatus,
        string calldata _reason
    ) external onlyOperator {
        require(attestations[_subjectHash].subjectHash != bytes32(0), "No attestation found");
        require(_newStatus != Status.None, "Invalid status");
        attestations[_subjectHash].status = _newStatus;
        attestations[_subjectHash].reason = _reason;
        emit AppealResolved(_subjectHash, _newStatus, msg.sender, _reason);
    }

    function getAttestation(bytes32 _subjectHash) external view returns (Attestation memory) {
        return attestations[_subjectHash];
    }

    function getAppealCount(bytes32 _subjectHash) external view returns (uint256) {
        return appealCount[_subjectHash];
    }
}

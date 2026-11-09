// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "./OperatorPrivileges.sol";

/**
 * @title PrivacyPreservingKYCRegistryV2
 * @notice Append-only KYC attestation history with hashed reasons,
 *         tracked appeal lifecycle, and operator-gated resolution.
 */
contract PrivacyPreservingKYCRegistryV2 {
    OperatorPrivileges public immutable privileges;

    enum Status { None, Pending, Cleared, Flagged, Revoked }
    enum AppealState { None, Open, Resolved }

    struct Attestation {
        bytes32 subjectHash;
        bytes32 zkProofHash;
        Status status;
        bytes32 reasonHash;
        uint256 recordedAt;
        address recordedBy;
    }

    struct Appeal {
        bytes32 subjectHash;
        AppealState state;
        address appellant;
        uint256 openedAt;
        bytes32 resolutionReasonHash;
        address resolvedBy;
        uint256 resolvedAt;
    }

    mapping(bytes32 => Attestation[]) public attestationHistory;
    mapping(bytes32 => uint256) public attestationCount;

    mapping(uint256 => Appeal) public appeals;
    mapping(bytes32 => uint256) public openAppealId;
    uint256 public nextAppealId = 1;

    event AttestationRecorded(
        bytes32 indexed subjectHash,
        uint256 indexed version,
        Status status,
        bytes32 zkProofHash,
        bytes32 reasonHash,
        address indexed recordedBy,
        uint256 recordedAt
    );

    event AppealOpened(
        uint256 indexed appealId,
        bytes32 indexed subjectHash,
        address indexed appellant,
        uint256 openedAt
    );

    event AppealResolved(
        uint256 indexed appealId,
        bytes32 indexed subjectHash,
        Status newStatus,
        bytes32 resolutionReasonHash,
        address indexed resolvedBy,
        uint256 resolvedAt
    );

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
        bytes32 _reasonHash
    ) external onlyOperator {
        require(_subjectHash != bytes32(0), "Invalid subject hash");
        require(_status != Status.None, "Invalid status");

        attestationHistory[_subjectHash].push(
            Attestation({
                subjectHash: _subjectHash,
                zkProofHash: _zkProofHash,
                status: _status,
                reasonHash: _reasonHash,
                recordedAt: block.timestamp,
                recordedBy: msg.sender
            })
        );

        attestationCount[_subjectHash] = attestationHistory[_subjectHash].length;

        uint256 version = attestationHistory[_subjectHash].length;

        emit AttestationRecorded(
            _subjectHash,
            version,
            _status,
            _zkProofHash,
            _reasonHash,
            msg.sender,
            block.timestamp
        );
    }

    function appeal(bytes32 _subjectHash) external {
        require(attestationHistory[_subjectHash].length > 0, "No attestation");
        require(openAppealId[_subjectHash] == 0, "Open appeal exists");

        uint256 appealId = nextAppealId;
        nextAppealId++;

        appeals[appealId] = Appeal({
            subjectHash: _subjectHash,
            state: AppealState.Open,
            appellant: msg.sender,
            openedAt: block.timestamp,
            resolutionReasonHash: bytes32(0),
            resolvedBy: address(0),
            resolvedAt: 0
        });

        openAppealId[_subjectHash] = appealId;

        emit AppealOpened(appealId, _subjectHash, msg.sender, block.timestamp);
    }

    function resolveAppeal(
        uint256 _appealId,
        Status _newStatus,
        bytes32 _resolutionReasonHash
    ) external onlyOperator {
        require(_newStatus != Status.None, "Invalid status");

        Appeal storage appealRecord = appeals[_appealId];
        require(appealRecord.state == AppealState.Open, "Appeal not open");

        appealRecord.state = AppealState.Resolved;
        appealRecord.resolutionReasonHash = _resolutionReasonHash;
        appealRecord.resolvedBy = msg.sender;
        appealRecord.resolvedAt = block.timestamp;

        openAppealId[appealRecord.subjectHash] = 0;

        emit AppealResolved(
            _appealId,
            appealRecord.subjectHash,
            _newStatus,
            _resolutionReasonHash,
            msg.sender,
            block.timestamp
        );
    }

    function getAttestationVersion(
        bytes32 _subjectHash,
        uint256 _version
    ) external view returns (Attestation memory) {
        require(_version >= 1, "Invalid version");
        require(_version <= attestationHistory[_subjectHash].length, "Version not found");
        return attestationHistory[_subjectHash][_version - 1];
    }

    function getOpenAppealId(bytes32 _subjectHash) external view returns (uint256) {
        return openAppealId[_subjectHash];
    }
}

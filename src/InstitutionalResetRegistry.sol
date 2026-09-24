// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./OperatorPrivilegesV2.sol";

/**
 * @title InstitutionalResetRegistry
 * @notice On-chain record of institutional adaptations ("resets").
 *         Tracks when a successful model needs to be adapted due to
 *         new problems (success trap).
 *
 *         Directly addresses: Singapore 2026 reset pattern,
 *         CASE-014 State-Led Success Trap.
 */
contract InstitutionalResetRegistry {
    OperatorPrivilegesV2 public privileges;

    enum ResetStatus {
        PROPOSED,
        ACTIVE,
        COMPLETED,
        REVERTED
    }

    struct Reset {
        uint256 id;
        bytes32 institutionHash; // hash of institution name
        bytes32 domain; // education, housing, work, health, etc.
        string name;
        string reason;
        ResetStatus status;
        address proposer;
        uint256 proposedAt;
        uint256 activatedAt;
        uint256 completedAt;
        bytes32 evidenceHash; // hash of policy document
        uint256 approvals;
    }

    struct Approval {
        address approver;
        uint256 timestamp;
    }

    uint256 public resetCount;
    mapping(uint256 => Reset) internal _resets;
    mapping(uint256 => Approval[]) internal _approvals;
    mapping(uint256 => mapping(address => bool)) public hasApproved;
    mapping(bytes32 => uint256[]) internal _resetsByDomain;

    uint256 public constant APPROVAL_THRESHOLD = 2;

    event ResetProposed(uint256 indexed id, bytes32 indexed domain, string name, address proposer);
    event ResetApproved(uint256 indexed id, address approver, uint256 approvals);
    event ResetActivated(uint256 indexed id, address activator);
    event ResetCompleted(uint256 indexed id, address completer);
    event ResetReverted(uint256 indexed id, address reverter, string reason);

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not authorized operator");
        _;
    }

    modifier resetExists(uint256 id) {
        require(_resets[id].id != 0, "Reset not found");
        _;
    }

    constructor(address _privileges) {
        require(_privileges != address(0), "Invalid privileges");
        privileges = OperatorPrivilegesV2(_privileges);
    }

    // ─── PROPOSE ───

    function proposeReset(
        bytes32 institutionHash,
        bytes32 domain,
        string calldata name,
        string calldata reason,
        bytes32 evidenceHash
    ) external onlyOperator returns (uint256) {
        require(institutionHash != bytes32(0), "Institution required");
        require(domain != bytes32(0), "Domain required");
        require(bytes(name).length > 0, "Name required");
        require(bytes(reason).length > 0, "Reason required");

        resetCount++;
        uint256 id = resetCount;

        _resets[id] = Reset({
            id: id,
            institutionHash: institutionHash,
            domain: domain,
            name: name,
            reason: reason,
            status: ResetStatus.PROPOSED,
            proposer: msg.sender,
            proposedAt: block.timestamp,
            activatedAt: 0,
            completedAt: 0,
            evidenceHash: evidenceHash,
            approvals: 1
        });

        _approvals[id].push(Approval({approver: msg.sender, timestamp: block.timestamp}));
        hasApproved[id][msg.sender] = true;

        _resetsByDomain[domain].push(id);

        emit ResetProposed(id, domain, name, msg.sender);
        return id;
    }

    // ─── APPROVE ───

    function approveReset(uint256 id) external onlyOperator resetExists(id) {
        Reset storage r = _resets[id];
        require(r.status == ResetStatus.PROPOSED, "Not proposed");
        require(!hasApproved[id][msg.sender], "Already approved");

        hasApproved[id][msg.sender] = true;
        r.approvals++;

        _approvals[id].push(Approval({approver: msg.sender, timestamp: block.timestamp}));

        emit ResetApproved(id, msg.sender, r.approvals);
    }

    // ─── ACTIVATE ───

    function activateReset(uint256 id) external onlyOperator resetExists(id) {
        Reset storage r = _resets[id];
        require(r.status == ResetStatus.PROPOSED, "Not proposed");
        require(r.approvals >= APPROVAL_THRESHOLD, "Insufficient approvals");

        r.status = ResetStatus.ACTIVE;
        r.activatedAt = block.timestamp;

        emit ResetActivated(id, msg.sender);
    }

    // ─── COMPLETE ───

    function completeReset(uint256 id) external onlyOperator resetExists(id) {
        Reset storage r = _resets[id];
        require(r.status == ResetStatus.ACTIVE, "Not active");

        r.status = ResetStatus.COMPLETED;
        r.completedAt = block.timestamp;

        emit ResetCompleted(id, msg.sender);
    }

    // ─── REVERT ───

    function revertReset(uint256 id, string calldata reason) external onlyOperator resetExists(id) {
        Reset storage r = _resets[id];
        require(r.status == ResetStatus.ACTIVE, "Not active");

        r.status = ResetStatus.REVERTED;

        emit ResetReverted(id, msg.sender, reason);
    }

    // ─── VIEWS ───

    function getReset(uint256 id) external view resetExists(id) returns (Reset memory) {
        return _resets[id];
    }

    function getResetsByDomain(bytes32 domain) external view returns (uint256[] memory) {
        return _resetsByDomain[domain];
    }

    function getApprovals(uint256 id) external view returns (Approval[] memory) {
        return _approvals[id];
    }

    function totalResets() external view returns (uint256) {
        return resetCount;
    }
}

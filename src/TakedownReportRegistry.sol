// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./OperatorPrivileges.sol";

/**
 * @title TakedownReportRegistry
 * @notice Tracks takedown requests through their lifecycle, including
 *         external filings with registrars, platforms, and dispute bodies.
 *
 * Status flow:
 *   REPORTED -> IN_PROGRESS -> AWAITING_PLATFORM -> AWAITING_APPROVAL -> TAKEN_DOWN
 *                                              \-> DISMISSED (any pre-resolution state)
 *
 * Takedown confirmation requires an operator distinct from the one who
 * requested approval. Reporting is permissionless; all state changes
 * require operator status.
 *
 * Subject, target, channel, external party, case number, and evidence
 * are all bytes32 hashes. The contract does not know what
 * "cloned-executive-profile" or "telegram-abuse-desk" means.
 */
contract TakedownReportRegistry {
    OperatorPrivileges public immutable privileges;

    enum Status {
        NONE,
        REPORTED,
        IN_PROGRESS,
        AWAITING_PLATFORM,
        AWAITING_APPROVAL,
        TAKEN_DOWN,
        DISMISSED
    }

    uint8 public constant STATUS_COUNT = 7;

    struct Report {
        bytes32 id;
        bytes32 subjectHash;
        bytes32 targetHash;
        bytes32 channelHash;
        bytes32 evidenceHash;
        bytes32 resolutionHash;
        bytes32 dismissalReason;
        bytes32 reportedToHash;
        bytes32 caseNumberHash;
        address reporter;
        address handler;
        address approver;
        Status  status;
        uint256 createdAt;
        uint256 updatedAt;
        uint256 filedAt;
        uint256 deadlineAt;
    }

    mapping(bytes32 => Report) public reports;
    bytes32[] public reportIds;

    mapping(bytes32 => mapping(uint8 => uint256)) public reportsBySubjectStatus;
    mapping(bytes32 => mapping(uint8 => uint256)) public reportsByChannelStatus;
    mapping(bytes32 => mapping(uint8 => uint256)) public reportsByTargetStatus;
    mapping(uint8 => uint256) public reportsByStatus;

    // Transitions per 30-day bucket by destination status
    mapping(uint256 => mapping(uint8 => uint256)) public transitionsByMonth;

    event ReportFiled(
        bytes32 indexed id,
        bytes32 indexed subjectHash,
        bytes32 indexed targetHash,
        bytes32 channelHash,
        address reporter,
        bytes32 evidenceHash
    );
    event StatusAdvanced(
        bytes32 indexed id,
        Status fromStatus,
        Status toStatus,
        address handler
    );
    event TakedownConfirmed(
        bytes32 indexed id,
        address approver,
        bytes32 resolutionHash
    );
    event ReportDismissed(
        bytes32 indexed id,
        address handler,
        bytes32 reasonHash
    );
    event ExternalFilingRecorded(
        bytes32 indexed id,
        bytes32 reportedToHash,
        bytes32 caseNumberHash,
        uint256 deadlineAt,
        address handler
    );

    modifier onlyOperator() {
        require(privileges.isOperator(msg.sender), "Not authorized operator");
        _;
    }

    modifier reportExists(bytes32 id) {
        require(reports[id].createdAt != 0, "Report not found");
        _;
    }

    constructor(address _privileges) {
        require(_privileges != address(0), "privileges=0");
        privileges = OperatorPrivileges(_privileges);
    }

    // ─────────────────────────────────────────────────────────────
    // Filing — permissionless
    // ─────────────────────────────────────────────────────────────

    function fileReport(
        bytes32 subjectHash,
        bytes32 targetHash,
        bytes32 channelHash,
        bytes32 evidenceHash
    ) external returns (bytes32) {
        require(subjectHash != bytes32(0), "subjectHash=0");
        require(targetHash  != bytes32(0), "targetHash=0");
        require(channelHash != bytes32(0), "channelHash=0");

        bytes32 id = keccak256(abi.encode(
            subjectHash, targetHash, channelHash,
            msg.sender, block.timestamp, reportIds.length
        ));
        require(reports[id].createdAt == 0, "Report exists");

        reports[id] = Report({
            id: id,
            subjectHash: subjectHash,
            targetHash: targetHash,
            channelHash: channelHash,
            evidenceHash: evidenceHash,
            resolutionHash: bytes32(0),
            dismissalReason: bytes32(0),
            reportedToHash: bytes32(0),
            caseNumberHash: bytes32(0),
            reporter: msg.sender,
            handler: address(0),
            approver: address(0),
            status: Status.REPORTED,
            createdAt: block.timestamp,
            updatedAt: block.timestamp,
            filedAt: 0,
            deadlineAt: 0
        });
        reportIds.push(id);

        reportsBySubjectStatus[subjectHash][uint8(Status.REPORTED)] += 1;
        reportsByChannelStatus[channelHash][uint8(Status.REPORTED)] += 1;
        reportsByTargetStatus[targetHash][uint8(Status.REPORTED)]  += 1;
        reportsByStatus[uint8(Status.REPORTED)] += 1;
        transitionsByMonth[_month()][uint8(Status.REPORTED)] += 1;

        emit ReportFiled(id, subjectHash, targetHash, channelHash, msg.sender, evidenceHash);
        return id;
    }

    // ─────────────────────────────────────────────────────────────
    // Triage — operator
    // ─────────────────────────────────────────────────────────────

    function markInProgress(bytes32 id) external onlyOperator reportExists(id) {
        Report storage r = reports[id];
        require(
            r.status == Status.REPORTED || r.status == Status.AWAITING_PLATFORM,
            "Cannot mark in progress from this state"
        );
        _advance(r, Status.IN_PROGRESS, msg.sender);
    }

    function markAwaitingPlatform(bytes32 id) external onlyOperator reportExists(id) {
        Report storage r = reports[id];
        require(
            r.status == Status.REPORTED || r.status == Status.IN_PROGRESS,
            "Cannot await platform from this state"
        );
        _advance(r, Status.AWAITING_PLATFORM, msg.sender);
    }

    function requestApproval(bytes32 id) external onlyOperator reportExists(id) {
        Report storage r = reports[id];
        require(
            r.status == Status.REPORTED ||
            r.status == Status.IN_PROGRESS ||
            r.status == Status.AWAITING_PLATFORM,
            "Cannot request approval from this state"
        );
        r.handler = msg.sender;
        _advance(r, Status.AWAITING_APPROVAL, msg.sender);
    }

    // ─────────────────────────────────────────────────────────────
    // Resolution — requires independent operator
    // ─────────────────────────────────────────────────────────────

    function confirmTakedown(bytes32 id, bytes32 resolutionHash)
        external
        onlyOperator
        reportExists(id)
    {
        Report storage r = reports[id];
        require(r.status == Status.AWAITING_APPROVAL, "Not awaiting approval");
        require(resolutionHash != bytes32(0), "resolutionHash=0");
        require(msg.sender != r.handler, "Approver must differ from handler");

        r.resolutionHash = resolutionHash;
        r.approver = msg.sender;
        _advance(r, Status.TAKEN_DOWN, msg.sender);

        emit TakedownConfirmed(id, msg.sender, resolutionHash);
    }

    function dismissReport(bytes32 id, bytes32 reasonHash)
        external
        onlyOperator
        reportExists(id)
    {
        Report storage r = reports[id];
        require(
            r.status == Status.REPORTED ||
            r.status == Status.IN_PROGRESS ||
            r.status == Status.AWAITING_PLATFORM ||
            r.status == Status.AWAITING_APPROVAL,
            "Cannot dismiss from this state"
        );
        r.dismissalReason = reasonHash;
        _advance(r, Status.DISMISSED, msg.sender);

        emit ReportDismissed(id, msg.sender, reasonHash);
    }

    // ─────────────────────────────────────────────────────────────
    // External filing metadata
    // ─────────────────────────────────────────────────────────────

    /// @notice Record that the report has been filed with an external party
    ///         (registrar, platform, dispute-resolution body). Updates filing
    ///         metadata only; does not change status.
    function recordExternalFiling(
        bytes32 id,
        bytes32 reportedToHash,
        bytes32 caseNumberHash,
        uint256 deadlineAt
    ) external onlyOperator reportExists(id) {
        require(reportedToHash != bytes32(0), "reportedToHash=0");
        Report storage r = reports[id];
        require(
            r.status != Status.TAKEN_DOWN && r.status != Status.DISMISSED,
            "Cannot file externally after closure"
        );
        r.reportedToHash = reportedToHash;
        r.caseNumberHash = caseNumberHash;
        r.filedAt = block.timestamp;
        r.deadlineAt = deadlineAt;
        r.updatedAt = block.timestamp;
        emit ExternalFilingRecorded(id, reportedToHash, caseNumberHash, deadlineAt, msg.sender);
    }

    // ─────────────────────────────────────────────────────────────
    // Withdrawal — reporter, before triage
    // ─────────────────────────────────────────────────────────────

    function withdrawReport(bytes32 id) external reportExists(id) {
        Report storage r = reports[id];
        require(msg.sender == r.reporter, "Only reporter");
        require(r.status == Status.REPORTED, "Cannot withdraw after triage");
        _advance(r, Status.DISMISSED, msg.sender);
    }

    // ─────────────────────────────────────────────────────────────
    // Views
    // ─────────────────────────────────────────────────────────────

    function getReport(bytes32 id) external view returns (Report memory) {
        return reports[id];
    }

    function getReportCount() external view returns (uint256) {
        return reportIds.length;
    }

    function getSubjectReport(bytes32 subjectHash)
        external view returns (uint256[7] memory byStatus)
    {
        for (uint8 i = 0; i < STATUS_COUNT; i++) {
            byStatus[i] = reportsBySubjectStatus[subjectHash][i];
        }
    }

    function getChannelReport(bytes32 channelHash)
        external view returns (uint256[7] memory byStatus)
    {
        for (uint8 i = 0; i < STATUS_COUNT; i++) {
            byStatus[i] = reportsByChannelStatus[channelHash][i];
        }
    }

    function getTargetReport(bytes32 targetHash)
        external view returns (uint256[7] memory byStatus)
    {
        for (uint8 i = 0; i < STATUS_COUNT; i++) {
            byStatus[i] = reportsByTargetStatus[targetHash][i];
        }
    }

    function getGlobalReport() external view returns (uint256[7] memory byStatus) {
        for (uint8 i = 0; i < STATUS_COUNT; i++) {
            byStatus[i] = reportsByStatus[i];
        }
    }

    function getMonthReport(uint256 month)
        external view returns (uint256[7] memory byStatus)
    {
        for (uint8 i = 0; i < STATUS_COUNT; i++) {
            byStatus[i] = transitionsByMonth[month][i];
        }
    }

    function getExternalPartyReport(bytes32 reportedToHash)
        external view returns (uint256[7] memory byStatus)
    {
        for (uint256 i = 0; i < reportIds.length; i++) {
            Report storage r = reports[reportIds[i]];
            if (r.reportedToHash == reportedToHash) {
                byStatus[uint8(r.status)] += 1;
            }
        }
    }

    // ─────────────────────────────────────────────────────────────
    // Internal
    // ─────────────────────────────────────────────────────────────

    function _advance(Report storage r, Status to, address handler) internal {
        Status from = r.status;
        reportsBySubjectStatus[r.subjectHash][uint8(from)] -= 1;
        reportsByChannelStatus[r.channelHash][uint8(from)] -= 1;
        reportsByTargetStatus[r.targetHash][uint8(from)]  -= 1;
        reportsByStatus[uint8(from)] -= 1;

        r.status = to;
        r.handler = handler;
        r.updatedAt = block.timestamp;

        reportsBySubjectStatus[r.subjectHash][uint8(to)] += 1;
        reportsByChannelStatus[r.channelHash][uint8(to)] += 1;
        reportsByTargetStatus[r.targetHash][uint8(to)]  += 1;
        reportsByStatus[uint8(to)] += 1;
        transitionsByMonth[_month()][uint8(to)] += 1;

        emit StatusAdvanced(r.id, from, to, handler);
    }

    function _month() internal view returns (uint256) {
        return block.timestamp / 30 days;
    }
}

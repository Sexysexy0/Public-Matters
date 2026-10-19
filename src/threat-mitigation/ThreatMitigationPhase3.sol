// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title ThreatMitigationPhase3
 * @notice Tracks fake Telegram / platform groups from report to resolution.
 *
 * Lifecycle: REPORTED -> AWAITING_PLATFORM -> PLATFORM_RESPONDED
 *         -> REMOVED | REFUSED | ESCALATED | ABANDONED
 */
contract ThreatMitigationPhase3 {
    enum PlatformStatus {
        REPORTED,
        AWAITING_PLATFORM,
        PLATFORM_RESPONDED,
        REMOVED,
        REFUSED,
        ESCALATED,
        ABANDONED
    }

    enum Severity {
        LOW,
        MEDIUM,
        HIGH,
        CRITICAL
    }

    struct PlatformReport {
        bytes32 id;
        string platformName;
        string groupHandle;
        string platformTicketId;
        string platformResponse;
        Severity severity;
        PlatformStatus status;
        bytes32 evidenceHash;
        uint256 reportedAt;
        uint256 lastUpdatedAt;
        uint256 responseDeadline;
        uint256 resolvedAt;
    }

    address public governor;
    address public logger;

    mapping(bytes32 => PlatformReport) public reports;
    bytes32[] public reportIds;
    mapping(PlatformStatus => uint256) public countByStatus;

    uint256 public defaultResponseWindow = 7 days;

    event PlatformReportSubmitted(
        bytes32 indexed id, string platformName, string groupHandle, Severity severity, uint256 responseDeadline
    );

    event PlatformStatusChanged(bytes32 indexed id, PlatformStatus oldStatus, PlatformStatus newStatus, string notes);

    event PlatformResponseRecorded(bytes32 indexed id, string ticketId, string response);

    event PlatformResolved(bytes32 indexed id, PlatformStatus finalStatus, uint256 resolvedAt);

    event GovernorChanged(address indexed oldGov, address indexed newGov);
    event ResponseWindowUpdated(uint256 oldWindow, uint256 newWindow);

    modifier onlyGovernor() {
        require(msg.sender == governor, "Unauthorized: not governor");
        _;
    }

    modifier onlyLogger() {
        require(msg.sender == logger || msg.sender == governor, "Unauthorized: not logger");
        _;
    }

    modifier reportExists(bytes32 id) {
        require(reports[id].reportedAt != 0, "Report not found");
        _;
    }

    constructor() {
        governor = msg.sender;
        logger = msg.sender;
    }

    function setGovernor(address newGov) external onlyGovernor {
        require(newGov != address(0), "Zero address");
        emit GovernorChanged(governor, newGov);
        governor = newGov;
    }

    function setLogger(address newLogger) external onlyGovernor {
        require(newLogger != address(0), "Zero address");
        logger = newLogger;
    }

    function setResponseWindow(uint256 newWindow) external onlyGovernor {
        require(newWindow >= 1 days && newWindow <= 90 days, "Out of range");
        emit ResponseWindowUpdated(defaultResponseWindow, newWindow);
        defaultResponseWindow = newWindow;
    }

    function submitPlatformReport(
        bytes32 id,
        string calldata platformName,
        string calldata groupHandle,
        Severity severity,
        bytes32 evidenceHash
    ) external onlyLogger {
        require(reports[id].reportedAt == 0, "Report already exists");

        uint256 deadline = block.timestamp + defaultResponseWindow;

        reports[id] = PlatformReport({
            id: id,
            platformName: platformName,
            groupHandle: groupHandle,
            platformTicketId: "",
            platformResponse: "",
            severity: severity,
            status: PlatformStatus.AWAITING_PLATFORM,
            evidenceHash: evidenceHash,
            reportedAt: block.timestamp,
            lastUpdatedAt: block.timestamp,
            responseDeadline: deadline,
            resolvedAt: 0
        });

        reportIds.push(id);
        countByStatus[PlatformStatus.REPORTED]++;
        countByStatus[PlatformStatus.AWAITING_PLATFORM]++;

        emit PlatformReportSubmitted(id, platformName, groupHandle, severity, deadline);
    }

    function recordPlatformResponse(bytes32 id, string calldata ticketId, string calldata response)
        external
        onlyLogger
        reportExists(id)
    {
        PlatformReport storage r = reports[id];
        PlatformStatus oldStatus = r.status;

        countByStatus[oldStatus]--;
        countByStatus[PlatformStatus.PLATFORM_RESPONDED]++;
        r.status = PlatformStatus.PLATFORM_RESPONDED;
        r.platformTicketId = ticketId;
        r.platformResponse = response;
        r.lastUpdatedAt = block.timestamp;

        emit PlatformResponseRecorded(id, ticketId, response);
        emit PlatformStatusChanged(id, oldStatus, PlatformStatus.PLATFORM_RESPONDED, response);
    }

    function updateStatus(bytes32 id, PlatformStatus newStatus, string calldata notes)
        external
        onlyLogger
        reportExists(id)
    {
        PlatformReport storage r = reports[id];
        PlatformStatus oldStatus = r.status;

        countByStatus[oldStatus]--;
        countByStatus[newStatus]++;
        r.status = newStatus;
        r.lastUpdatedAt = block.timestamp;

        emit PlatformStatusChanged(id, oldStatus, newStatus, notes);
    }

    function resolve(bytes32 id, PlatformStatus finalStatus) external onlyGovernor reportExists(id) {
        require(
            finalStatus == PlatformStatus.REMOVED || finalStatus == PlatformStatus.REFUSED
                || finalStatus == PlatformStatus.ESCALATED || finalStatus == PlatformStatus.ABANDONED,
            "Invalid final status"
        );

        PlatformReport storage r = reports[id];
        require(r.resolvedAt == 0, "Already resolved");

        countByStatus[r.status]--;
        countByStatus[finalStatus]++;
        r.status = finalStatus;
        r.resolvedAt = block.timestamp;
        r.lastUpdatedAt = block.timestamp;

        emit PlatformResolved(id, finalStatus, block.timestamp);
    }

    // ─── Views ──────────────────────────────────────────────

    function getReport(bytes32 id) external view reportExists(id) returns (PlatformReport memory) {
        return reports[id];
    }

    function getAllReportIds() external view returns (bytes32[] memory) {
        return reportIds;
    }

    function totalReports() external view returns (uint256) {
        return reportIds.length;
    }

    function isPastDeadline(bytes32 id) external view reportExists(id) returns (bool) {
        return block.timestamp > reports[id].responseDeadline && reports[id].resolvedAt == 0;
    }

    function activeCount() external view returns (uint256) {
        return countByStatus[PlatformStatus.REPORTED] + countByStatus[PlatformStatus.AWAITING_PLATFORM]
            + countByStatus[PlatformStatus.PLATFORM_RESPONDED];
    }
}

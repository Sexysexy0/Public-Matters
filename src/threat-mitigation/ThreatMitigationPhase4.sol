// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title ThreatMitigationPhase4
 * @notice Tracks executive/identity impersonation from detection to action.
 *
 * Lifecycle: DETECTED -> UNDER_REVIEW -> ACTION_AUTHORIZED
 *         -> ACTION_TAKEN -> RESOLVED | DEFERRED
 */
contract ThreatMitigationPhase4 {
    enum ImpersonationStatus {
        DETECTED,
        UNDER_REVIEW,
        ACTION_AUTHORIZED,
        ACTION_TAKEN,
        RESOLVED,
        DEFERRED
    }

    enum ActionType {
        NONE,
        PLATFORM_REPORT,
        LEGAL_NOTICE,
        PUBLIC_STATEMENT,
        LAW_ENFORCEMENT,
        CIVIL_SUIT
    }

    struct ExecutiveImpersonation {
        bytes32 id;
        string executiveName;
        string impersonatedRole;
        string socialNetwork;
        string profileUrl;
        ImpersonationStatus status;
        ActionType actionType;
        bytes32 evidenceHash;
        bytes32 actionEvidenceHash;
        uint256 detectedAt;
        uint256 lastUpdatedAt;
        uint256 resolvedAt;
        string notes;
    }

    address public governor;
    address public reviewer;

    mapping(bytes32 => ExecutiveImpersonation) public impersonations;
    bytes32[] public impersonationIds;
    mapping(ImpersonationStatus => uint256) public countByStatus;

    event ImpersonationDetected(
        bytes32 indexed id, string executiveName, string socialNetwork, string profileUrl, bytes32 evidenceHash
    );

    event ImpersonationStatusChanged(
        bytes32 indexed id, ImpersonationStatus oldStatus, ImpersonationStatus newStatus, string notes
    );

    event ActionAuthorized(bytes32 indexed id, ActionType actionType, string notes);

    event ActionCompleted(bytes32 indexed id, ActionType actionType, bytes32 actionEvidenceHash);

    event ImpersonationResolved(bytes32 indexed id, ImpersonationStatus finalStatus, uint256 resolvedAt);

    event GovernorChanged(address indexed oldGov, address indexed newGov);

    modifier onlyGovernor() {
        require(msg.sender == governor, "Unauthorized: not governor");
        _;
    }

    modifier onlyReviewer() {
        require(msg.sender == reviewer || msg.sender == governor, "Unauthorized: not reviewer");
        _;
    }

    modifier impersonationExists(bytes32 id) {
        require(impersonations[id].detectedAt != 0, "Not found");
        _;
    }

    constructor() {
        governor = msg.sender;
        reviewer = msg.sender;
    }

    function setGovernor(address newGov) external onlyGovernor {
        require(newGov != address(0), "Zero address");
        emit GovernorChanged(governor, newGov);
        governor = newGov;
    }

    function setReviewer(address newReviewer) external onlyGovernor {
        require(newReviewer != address(0), "Zero address");
        reviewer = newReviewer;
    }

    function registerImpersonation(
        bytes32 id,
        string calldata executiveName,
        string calldata impersonatedRole,
        string calldata socialNetwork,
        string calldata profileUrl,
        bytes32 evidenceHash
    ) external onlyReviewer {
        require(impersonations[id].detectedAt == 0, "Already registered");

        impersonations[id] = ExecutiveImpersonation({
            id: id,
            executiveName: executiveName,
            impersonatedRole: impersonatedRole,
            socialNetwork: socialNetwork,
            profileUrl: profileUrl,
            status: ImpersonationStatus.DETECTED,
            actionType: ActionType.NONE,
            evidenceHash: evidenceHash,
            actionEvidenceHash: bytes32(0),
            detectedAt: block.timestamp,
            lastUpdatedAt: block.timestamp,
            resolvedAt: 0,
            notes: ""
        });

        impersonationIds.push(id);
        countByStatus[ImpersonationStatus.DETECTED]++;

        emit ImpersonationDetected(id, executiveName, socialNetwork, profileUrl, evidenceHash);
    }

    function updateStatus(bytes32 id, ImpersonationStatus newStatus, string calldata notes)
        external
        onlyReviewer
        impersonationExists(id)
    {
        ExecutiveImpersonation storage imp = impersonations[id];
        ImpersonationStatus oldStatus = imp.status;

        countByStatus[oldStatus]--;
        countByStatus[newStatus]++;
        imp.status = newStatus;
        imp.lastUpdatedAt = block.timestamp;
        imp.notes = notes;

        emit ImpersonationStatusChanged(id, oldStatus, newStatus, notes);
    }

    function authorizeAction(bytes32 id, ActionType actionType, string calldata notes)
        external
        onlyGovernor
        impersonationExists(id)
    {
        require(actionType != ActionType.NONE, "Action type required");

        ExecutiveImpersonation storage imp = impersonations[id];
        require(
            imp.status == ImpersonationStatus.DETECTED || imp.status == ImpersonationStatus.UNDER_REVIEW,
            "Invalid status for authorization"
        );

        ImpersonationStatus oldStatus = imp.status;
        countByStatus[oldStatus]--;
        countByStatus[ImpersonationStatus.ACTION_AUTHORIZED]++;

        imp.status = ImpersonationStatus.ACTION_AUTHORIZED;
        imp.actionType = actionType;
        imp.lastUpdatedAt = block.timestamp;
        imp.notes = notes;

        emit ActionAuthorized(id, actionType, notes);
        emit ImpersonationStatusChanged(id, oldStatus, ImpersonationStatus.ACTION_AUTHORIZED, notes);
    }

    function completeAction(bytes32 id, bytes32 actionEvidenceHash) external onlyReviewer impersonationExists(id) {
        ExecutiveImpersonation storage imp = impersonations[id];
        require(imp.status == ImpersonationStatus.ACTION_AUTHORIZED, "Not authorized");

        countByStatus[ImpersonationStatus.ACTION_AUTHORIZED]--;
        countByStatus[ImpersonationStatus.ACTION_TAKEN]++;

        imp.status = ImpersonationStatus.ACTION_TAKEN;
        imp.actionEvidenceHash = actionEvidenceHash;
        imp.lastUpdatedAt = block.timestamp;

        emit ActionCompleted(id, imp.actionType, actionEvidenceHash);
        emit ImpersonationStatusChanged(id, ImpersonationStatus.ACTION_AUTHORIZED, ImpersonationStatus.ACTION_TAKEN, "");
    }

    function resolve(bytes32 id, ImpersonationStatus finalStatus, string calldata notes)
        external
        onlyGovernor
        impersonationExists(id)
    {
        require(
            finalStatus == ImpersonationStatus.RESOLVED || finalStatus == ImpersonationStatus.DEFERRED,
            "Invalid final status"
        );

        ExecutiveImpersonation storage imp = impersonations[id];
        require(imp.resolvedAt == 0, "Already resolved");

        countByStatus[imp.status]--;
        countByStatus[finalStatus]++;
        imp.status = finalStatus;
        imp.resolvedAt = block.timestamp;
        imp.lastUpdatedAt = block.timestamp;
        imp.notes = notes;

        emit ImpersonationResolved(id, finalStatus, block.timestamp);
    }

    // ─── Views ──────────────────────────────────────────────

    function getImpersonation(bytes32 id)
        external
        view
        impersonationExists(id)
        returns (ExecutiveImpersonation memory)
    {
        return impersonations[id];
    }

    function getAllImpersonationIds() external view returns (bytes32[] memory) {
        return impersonationIds;
    }

    function totalImpersonations() external view returns (uint256) {
        return impersonationIds.length;
    }

    function activeCount() external view returns (uint256) {
        return countByStatus[ImpersonationStatus.DETECTED] + countByStatus[ImpersonationStatus.UNDER_REVIEW]
            + countByStatus[ImpersonationStatus.ACTION_AUTHORIZED] + countByStatus[ImpersonationStatus.ACTION_TAKEN];
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title PrivateFundInvestorProtection
 * @notice On-chain safeguards for retail-facing private-market funds:
 *         independent valuation attestations, transparent fee-impact
 *         calculations, and share-class fairness controls.
 */
contract PrivateFundInvestorProtection {
    enum ValuationMethod {
        NONE,
        INDEPENDENT_THIRD_PARTY,
        AUDITED,
        BOARD_REVIEWED
    }

    struct Valuer {
        bool approved;
        string organization;
        uint256 approvedAt;
    }

    struct ValuationAttestation {
        bytes32 assetId;
        uint256 valuation;
        uint256 valuedAt;
        ValuationMethod method;
        address valuer;
        bytes32 methodologyHash;
        string notes;
    }

    struct ShareClass {
        string name;
        uint256 managementFeeBps;
        uint256 performanceFeeBps;
        uint256 minimumInvestment;
        bool approved;
        uint256 approvedAt;
        bytes32 disclosureHash;
    }

    address public governor;
    address public independentBoard;

    mapping(address => Valuer) public valuers;
    mapping(bytes32 => ValuationAttestation) public valuations;
    mapping(bytes32 => ShareClass) public shareClasses;

    bytes32[] public shareClassIds;
    bytes32[] public valuationIds;

    event ValuerApproved(address indexed valuer, string organization);
    event ValuerRevoked(address indexed valuer);
    event ValuationAttested(
        bytes32 indexed valuationId,
        bytes32 indexed assetId,
        uint256 valuation,
        ValuationMethod method,
        address indexed valuer
    );
    event ShareClassProposed(bytes32 indexed classId, string name);
    event ShareClassApproved(bytes32 indexed classId, uint256 managementFeeBps, uint256 performanceFeeBps);
    event DisclosureUpdated(bytes32 indexed classId, bytes32 disclosureHash);
    event GovernorChanged(address indexed oldGovernor, address indexed newGovernor);
    event IndependentBoardChanged(address indexed oldBoard, address indexed newBoard);

    error Unauthorized();
    error ZeroAddress();
    error ValuerNotApproved();
    error InvalidValuation();
    error InvalidMethod();
    error ShareClassNotFound();
    error ShareClassAlreadyApproved();
    error PerformanceFeeTooHigh();
    error InvalidFee();
    error InvalidDisclosure();

    modifier onlyGovernor() {
        if (msg.sender != governor) revert Unauthorized();
        _;
    }

    modifier onlyIndependentBoard() {
        if (msg.sender != independentBoard) revert Unauthorized();
        _;
    }

    constructor(address initialIndependentBoard) {
        if (initialIndependentBoard == address(0)) revert ZeroAddress();
        governor = msg.sender;
        independentBoard = initialIndependentBoard;
    }

    function setGovernor(address newGovernor) external onlyGovernor {
        if (newGovernor == address(0)) revert ZeroAddress();
        emit GovernorChanged(governor, newGovernor);
        governor = newGovernor;
    }

    function setIndependentBoard(address newBoard) external onlyGovernor {
        if (newBoard == address(0)) revert ZeroAddress();
        emit IndependentBoardChanged(independentBoard, newBoard);
        independentBoard = newBoard;
    }

    function approveValuer(address valuer, string calldata organization) external onlyGovernor {
        if (valuer == address(0)) revert ZeroAddress();
        valuers[valuer] = Valuer({approved: true, organization: organization, approvedAt: block.timestamp});
        emit ValuerApproved(valuer, organization);
    }

    function revokeValuer(address valuer) external onlyGovernor {
        delete valuers[valuer];
        emit ValuerRevoked(valuer);
    }

    function attestValuation(
        bytes32 assetId,
        uint256 valuation,
        ValuationMethod method,
        bytes32 methodologyHash,
        string calldata notes
    ) external returns (bytes32 valuationId) {
        if (!valuers[msg.sender].approved) revert ValuerNotApproved();
        if (valuation == 0) revert InvalidValuation();
        if (
            method != ValuationMethod.INDEPENDENT_THIRD_PARTY && method != ValuationMethod.AUDITED
                && method != ValuationMethod.BOARD_REVIEWED
        ) revert InvalidMethod();

        valuationId = keccak256(abi.encodePacked(assetId, valuation, method, msg.sender, block.timestamp));

        valuations[valuationId] = ValuationAttestation({
            assetId: assetId,
            valuation: valuation,
            valuedAt: block.timestamp,
            method: method,
            valuer: msg.sender,
            methodologyHash: methodologyHash,
            notes: notes
        });

        valuationIds.push(valuationId);

        emit ValuationAttested(valuationId, assetId, valuation, method, msg.sender);
    }

    function proposeShareClass(
        bytes32 classId,
        string calldata name,
        uint256 managementFeeBps,
        uint256 performanceFeeBps,
        uint256 minimumInvestment,
        bytes32 disclosureHash
    ) external onlyGovernor {
        if (shareClasses[classId].approvedAt != 0) {
            revert ShareClassAlreadyApproved();
        }
        if (managementFeeBps > 2_000) revert InvalidFee();
        if (performanceFeeBps > 2_000) revert InvalidFee();
        if (disclosureHash == bytes32(0)) revert InvalidDisclosure();

        shareClasses[classId] = ShareClass({
            name: name,
            managementFeeBps: managementFeeBps,
            performanceFeeBps: performanceFeeBps,
            minimumInvestment: minimumInvestment,
            approved: false,
            approvedAt: 0,
            disclosureHash: disclosureHash
        });

        shareClassIds.push(classId);
        emit ShareClassProposed(classId, name);
    }

    function approveShareClass(bytes32 classId) external onlyIndependentBoard {
        ShareClass storage shareClass = shareClasses[classId];
        if (shareClass.approvedAt == 0) revert ShareClassNotFound();
        if (shareClass.approved) revert ShareClassAlreadyApproved();

        if (classId != bytes32(0)) {
            ShareClass storage baseClass = shareClasses[bytes32(0)];
            if (baseClass.approved && shareClass.performanceFeeBps > baseClass.performanceFeeBps) {
                revert PerformanceFeeTooHigh();
            }
        }

        shareClass.approved = true;
        shareClass.approvedAt = block.timestamp;

        emit ShareClassApproved(classId, shareClass.managementFeeBps, shareClass.performanceFeeBps);
    }

    function updateDisclosure(bytes32 classId, bytes32 disclosureHash) external onlyGovernor {
        ShareClass storage shareClass = shareClasses[classId];
        if (shareClass.approvedAt == 0) revert ShareClassNotFound();
        if (disclosureHash == bytes32(0)) revert InvalidDisclosure();

        shareClass.disclosureHash = disclosureHash;
        emit DisclosureUpdated(classId, disclosureHash);
    }

    function calculateNetReturn(
        int256 grossReturnBps,
        uint256 managementFeeBps,
        uint256 performanceFeeBps,
        int256 highWaterMarkBps
    ) external pure returns (int256 netReturnBps, int256 performanceFeeAmountBps) {
        int256 afterManagementFee = grossReturnBps - int256(managementFeeBps);

        if (afterManagementFee <= highWaterMarkBps || afterManagementFee <= 0) {
            return (afterManagementFee, 0);
        }

        int256 gainAboveHighWaterMark = afterManagementFee - highWaterMarkBps;
        performanceFeeAmountBps = (gainAboveHighWaterMark * int256(performanceFeeBps)) / 10_000;

        netReturnBps = afterManagementFee - performanceFeeAmountBps;
    }

    function getShareClass(bytes32 classId) external view returns (ShareClass memory) {
        return shareClasses[classId];
    }

    function getAllShareClassIds() external view returns (bytes32[] memory) {
        return shareClassIds;
    }

    function getAllValuationIds() external view returns (bytes32[] memory) {
        return valuationIds;
    }
}

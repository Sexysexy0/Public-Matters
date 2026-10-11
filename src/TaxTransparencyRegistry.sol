// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./OperatorPrivileges.sol";

/**
 * @title TaxTransparencyRegistry
 * @notice Append-only registry of tax assessment, reduction, and payment
 *         claims. Records claims with attribution; does not claim truth.
 *
 * Any address may file a taxpayer-side record. Operators may file a
 * BIR-side record. Both are permanent, both are queryable, both
 * attribute to the recorder. The gap between the two sides'
 * aggregates is the signal.
 *
 * Privacy: taxpayerHash should be keccak256(TIN + salt) where the salt
 * is held only by the taxpayer and BIR. Hashing plaintext TINs is
 * brute-forceable from 9 digits; the salt closes that.
 *
 * Query examples for a journalist or citizen:
 *   - getRDOReductionRate(rdoHash, Submitter.BIR_OPERATOR)
 *   - getRDOReductionRate(rdoHash, Submitter.TAXPAYER)
 *   - getExaminerStats(hash, Submitter.BIR_OPERATOR)
 *   - getCategoryReductionRate(Category.MSME, Submitter.BIR_OPERATOR)
 *     vs getCategoryReductionRate(Category.LARGE, Submitter.BIR_OPERATOR)
 */
contract TaxTransparencyRegistry {
    OperatorPrivileges public immutable privileges;

    enum Category { MSME, LARGE, INDIVIDUAL }
    enum ReductionReason { NEGOTIATED, ADJUSTED_ON_APPEAL, VOIDED, PROTEST_UPHELD }
    enum Submitter { BIR_OPERATOR, TAXPAYER }

    struct Assessment {
        bytes32 id;
        bytes32 taxpayerHash;
        bytes32 rdoHash;
        bytes32 examinerHash;
        uint256 assessedAmount;
        Category category;
        Submitter submitter;
        address recordedBy;
        bytes32 evidenceHash;
        uint256 timestamp;
    }

    struct Reduction {
        bytes32 id;
        bytes32 assessmentId;
        uint256 reducedAmount;
        ReductionReason reason;
        Submitter submitter;
        address recordedBy;
        bytes32 evidenceHash;
        uint256 timestamp;
    }

    struct Payment {
        bytes32 id;
        bytes32 assessmentId;   // 0 = advance payment (unattached)
        bytes32 taxpayerHash;
        uint256 amount;
        address recordedBy;
        bytes32 evidenceHash;
        uint256 timestamp;
    }

    mapping(bytes32 => Assessment) public assessments;
    mapping(bytes32 => Reduction) public reductions;
    mapping(bytes32 => Payment) public payments;

    bytes32[] public assessmentIds;
    bytes32[] public reductionIds;
    bytes32[] public paymentIds;

    mapping(bytes32 => bytes32[]) public reductionIdsByAssessment;
    mapping(bytes32 => bytes32[]) public paymentIdsByAssessment;

    // Aggregates by submitter: dim => submitterIndex => amount
    mapping(bytes32 => mapping(uint8 => uint256)) public assessedByRDO;
    mapping(bytes32 => mapping(uint8 => uint256)) public assessedByExaminer;
    mapping(uint8   => mapping(uint8 => uint256)) public assessedByCategory;

    mapping(bytes32 => mapping(uint8 => uint256)) public reducedByRDO;
    mapping(bytes32 => mapping(uint8 => uint256)) public reducedByExaminer;
    mapping(uint8   => mapping(uint8 => uint256)) public reducedByCategory;

    // Reduction base per submitter: sum of assessed amounts for assessments
    // this submitter has filed a reduction against. Counted once per
    // assessment, per submitter.
    mapping(bytes32 => mapping(uint8 => uint256)) public reducedBaseByRDO;
    mapping(bytes32 => mapping(uint8 => uint256)) public reducedBaseByExaminer;
    mapping(uint8   => mapping(uint8 => uint256)) public reducedBaseByCategory;
    mapping(bytes32 => mapping(uint8 => bool))    public baseCounted;

    mapping(bytes32 => uint256) public assessmentCountByRDO;
    mapping(bytes32 => uint256) public assessmentCountByExaminer;
    mapping(uint8   => uint256) public assessmentCountByCategory;

    uint256 public totalAssessed;
    uint256 public totalReduced;
    uint256 public totalPaid;

    event AssessmentRecorded(
        bytes32 indexed id,
        bytes32 indexed rdoHash,
        bytes32 indexed examinerHash,
        uint256 assessedAmount,
        Category category,
        Submitter submitter,
        address recordedBy,
        bytes32 evidenceHash
    );

    event ReductionRecorded(
        bytes32 indexed id,
        bytes32 indexed assessmentId,
        uint256 reducedAmount,
        ReductionReason reason,
        Submitter submitter,
        address recordedBy,
        bytes32 evidenceHash
    );

    event PaymentRecorded(
        bytes32 indexed id,
        bytes32 indexed assessmentId,
        bytes32 indexed taxpayerHash,
        uint256 amount,
        address recordedBy,
        bytes32 evidenceHash
    );

    constructor(address _privileges) {
        require(_privileges != address(0), "privileges=0");
        privileges = OperatorPrivileges(_privileges);
    }

    // ─────────────────────────────────────────────────────────────
    // Recording
    // ─────────────────────────────────────────────────────────────

    function recordAssessment(
        bytes32 taxpayerHash,
        bytes32 rdoHash,
        bytes32 examinerHash,
        uint256 assessedAmount,
        Category category,
        Submitter submitter,
        bytes32 evidenceHash
    ) external returns (bytes32) {
        require(taxpayerHash != bytes32(0), "taxpayerHash=0");
        require(rdoHash != bytes32(0), "rdoHash=0");
        require(examinerHash != bytes32(0), "examinerHash=0");
        require(assessedAmount > 0, "amount=0");

        // BIR-side records require operator auth. Taxpayer-side records
        // are permissionless but permanently attributed to msg.sender.
        if (submitter == Submitter.BIR_OPERATOR) {
            require(privileges.isOperator(msg.sender), "Not authorized operator");
        }

        bytes32 id = keccak256(abi.encode(
            taxpayerHash, rdoHash, examinerHash,
            assessedAmount, category, submitter,
            msg.sender, block.timestamp, assessmentIds.length
        ));
        require(assessments[id].timestamp == 0, "Assessment exists");

        assessments[id] = Assessment({
            id: id,
            taxpayerHash: taxpayerHash,
            rdoHash: rdoHash,
            examinerHash: examinerHash,
            assessedAmount: assessedAmount,
            category: category,
            submitter: submitter,
            recordedBy: msg.sender,
            evidenceHash: evidenceHash,
            timestamp: block.timestamp
        });
        assessmentIds.push(id);

        uint8 s = uint8(submitter);
        uint8 c = uint8(category);
        assessedByRDO[rdoHash][s] += assessedAmount;
        assessedByExaminer[examinerHash][s] += assessedAmount;
        assessedByCategory[c][s] += assessedAmount;
        assessmentCountByRDO[rdoHash] += 1;
        assessmentCountByExaminer[examinerHash] += 1;
        assessmentCountByCategory[c] += 1;
        totalAssessed += assessedAmount;

        emit AssessmentRecorded(
            id, rdoHash, examinerHash, assessedAmount,
            category, submitter, msg.sender, evidenceHash
        );
        return id;
    }

    function recordReduction(
        bytes32 assessmentId,
        uint256 reducedAmount,
        ReductionReason reason,
        bytes32 evidenceHash
    ) external returns (bytes32) {
        Assessment storage a = assessments[assessmentId];
        require(a.timestamp != 0, "Assessment not found");
        require(reducedAmount > 0, "amount=0");
        require(reducedAmount <= a.assessedAmount, "Reduction exceeds assessment");

        Submitter submitter = privileges.isOperator(msg.sender)
            ? Submitter.BIR_OPERATOR
            : Submitter.TAXPAYER;

        bytes32 id = keccak256(abi.encode(
            assessmentId, reducedAmount, reason, submitter,
            msg.sender, block.timestamp, reductionIds.length
        ));
        require(reductions[id].timestamp == 0, "Reduction exists");

        reductions[id] = Reduction({
            id: id,
            assessmentId: assessmentId,
            reducedAmount: reducedAmount,
            reason: reason,
            submitter: submitter,
            recordedBy: msg.sender,
            evidenceHash: evidenceHash,
            timestamp: block.timestamp
        });
        reductionIds.push(id);
        reductionIdsByAssessment[assessmentId].push(id);

        uint8 s = uint8(submitter);
        uint8 c = uint8(a.category);
        reducedByRDO[a.rdoHash][s] += reducedAmount;
        reducedByExaminer[a.examinerHash][s] += reducedAmount;
        reducedByCategory[c][s] += reducedAmount;
        totalReduced += reducedAmount;

        // First reduction this submitter files against this assessment
        // contributes the assessed amount to their reduction base.
        if (!baseCounted[assessmentId][s]) {
            baseCounted[assessmentId][s] = true;
            reducedBaseByRDO[a.rdoHash][s] += a.assessedAmount;
            reducedBaseByExaminer[a.examinerHash][s] += a.assessedAmount;
            reducedBaseByCategory[c][s] += a.assessedAmount;
        }

        emit ReductionRecorded(
            id, assessmentId, reducedAmount, reason, submitter,
            msg.sender, evidenceHash
        );
        return id;
    }

    function recordPayment(
        bytes32 assessmentId,
        bytes32 taxpayerHash,
        uint256 amount,
        bytes32 evidenceHash
    ) external returns (bytes32) {
        require(taxpayerHash != bytes32(0), "taxpayerHash=0");
        require(amount > 0, "amount=0");
        if (assessmentId != bytes32(0)) {
            require(assessments[assessmentId].timestamp != 0, "Assessment not found");
        }

        bytes32 id = keccak256(abi.encode(
            assessmentId, taxpayerHash, amount,
            msg.sender, block.timestamp, paymentIds.length
        ));
        require(payments[id].timestamp == 0, "Payment exists");

        payments[id] = Payment({
            id: id,
            assessmentId: assessmentId,
            taxpayerHash: taxpayerHash,
            amount: amount,
            recordedBy: msg.sender,
            evidenceHash: evidenceHash,
            timestamp: block.timestamp
        });
        paymentIds.push(id);
        if (assessmentId != bytes32(0)) {
            paymentIdsByAssessment[assessmentId].push(id);
        }
        totalPaid += amount;

        emit PaymentRecorded(
            id, assessmentId, taxpayerHash, amount, msg.sender, evidenceHash
        );
        return id;
    }

    // ─────────────────────────────────────────────────────────────
    // Query views — the citizen surface
    // ─────────────────────────────────────────────────────────────

    function getAssessment(bytes32 id) external view returns (Assessment memory) {
        return assessments[id];
    }

    function getReduction(bytes32 id) external view returns (Reduction memory) {
        return reductions[id];
    }

    function getPayment(bytes32 id) external view returns (Payment memory) {
        return payments[id];
    }

    function getAssessmentCount() external view returns (uint256) {
        return assessmentIds.length;
    }

    function getReductionCount() external view returns (uint256) {
        return reductionIds.length;
    }

    function getPaymentCount() external view returns (uint256) {
        return paymentIds.length;
    }

    function getReductionsForAssessment(bytes32 assessmentId)
        external view returns (bytes32[] memory)
    {
        return reductionIdsByAssessment[assessmentId];
    }

    function getPaymentsForAssessment(bytes32 assessmentId)
        external view returns (bytes32[] memory)
    {
        return paymentIdsByAssessment[assessmentId];
    }

    /// @notice Reduction rate for an RDO, split by submitter, in bps.
    /// 7800 = 78% of assessed value was reduced.
    function getRDOReductionRate(bytes32 rdoHash, Submitter submitter)
        external view returns (uint256)
    {
        uint256 base = reducedBaseByRDO[rdoHash][uint8(submitter)];
        if (base == 0) return 0;
        return (reducedByRDO[rdoHash][uint8(submitter)] * 10000) / base;
    }

    function getExaminerReductionRate(bytes32 examinerHash, Submitter submitter)
        external view returns (uint256)
    {
        uint256 base = reducedBaseByExaminer[examinerHash][uint8(submitter)];
        if (base == 0) return 0;
        return (reducedByExaminer[examinerHash][uint8(submitter)] * 10000) / base;
    }

    function getCategoryReductionRate(Category category, Submitter submitter)
        external view returns (uint256)
    {
        uint8 c = uint8(category);
        uint256 base = reducedBaseByCategory[c][uint8(submitter)];
        if (base == 0) return 0;
        return (reducedByCategory[c][uint8(submitter)] * 10000) / base;
    }

    function getRDOStats(bytes32 rdoHash, Submitter submitter)
        external view returns (uint256 assessed, uint256 reduced, uint256 count)
    {
        return (
            assessedByRDO[rdoHash][uint8(submitter)],
            reducedByRDO[rdoHash][uint8(submitter)],
            assessmentCountByRDO[rdoHash]
        );
    }

    function getExaminerStats(bytes32 examinerHash, Submitter submitter)
        external view returns (uint256 assessed, uint256 reduced, uint256 count)
    {
        return (
            assessedByExaminer[examinerHash][uint8(submitter)],
            reducedByExaminer[examinerHash][uint8(submitter)],
            assessmentCountByExaminer[examinerHash]
        );
    }

    function getCategoryStats(Category category, Submitter submitter)
        external view returns (uint256 assessed, uint256 reduced, uint256 count)
    {
        uint8 c = uint8(category);
        return (
            assessedByCategory[c][uint8(submitter)],
            reducedByCategory[c][uint8(submitter)],
            assessmentCountByCategory[c]
        );
    }

    function getTotals() external view returns (uint256 assessed, uint256 reduced, uint256 paid) {
        return (totalAssessed, totalReduced, totalPaid);
    }
}

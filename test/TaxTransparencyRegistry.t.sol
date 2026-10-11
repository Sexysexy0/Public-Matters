// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivileges.sol";
import "../src/TaxTransparencyRegistry.sol";

contract TaxTransparencyRegistryTest is Test {
    OperatorPrivileges privileges;
    TaxTransparencyRegistry registry;

    address operator = vm.addr(1);
    address taxpayer = vm.addr(2);
    address stranger = vm.addr(3);

    bytes32 constant TAXPAYER_HASH = keccak256("TIN-123-456-789+salt-abc");
    bytes32 constant RDO_HASH = keccak256("RDO-039");
    bytes32 constant RDO_OTHER = keccak256("RDO-001");
    bytes32 constant EXAMINER_HASH = keccak256("examiner-042");

    function setUp() public {
        privileges = new OperatorPrivileges();
        registry = new TaxTransparencyRegistry(address(privileges));
        privileges.addOperator(operator);
    }

    function _fileBIRAssessment(uint256 amount, TaxTransparencyRegistry.Category cat)
        internal
        returns (bytes32)
    {
        vm.prank(operator);
        return registry.recordAssessment(
            TAXPAYER_HASH, RDO_HASH, EXAMINER_HASH, amount, cat,
            TaxTransparencyRegistry.Submitter.BIR_OPERATOR, keccak256("doc")
        );
    }

    function _fileTPAssessment(uint256 amount, TaxTransparencyRegistry.Category cat)
        internal
        returns (bytes32)
    {
        vm.prank(taxpayer);
        return registry.recordAssessment(
            TAXPAYER_HASH, RDO_HASH, EXAMINER_HASH, amount, cat,
            TaxTransparencyRegistry.Submitter.TAXPAYER, keccak256("screenshot")
        );
    }

    function testAnyoneCanFileTaxpayerAssessment() public {
        bytes32 id = _fileTPAssessment(1000 ether, TaxTransparencyRegistry.Category.MSME);

        TaxTransparencyRegistry.Assessment memory a = registry.getAssessment(id);
        assertEq(a.assessedAmount, 1000 ether);
        assertEq(uint8(a.submitter), uint8(TaxTransparencyRegistry.Submitter.TAXPAYER));
        assertEq(a.recordedBy, taxpayer);
    }

    function testStrangerCannotFileBIRAssessment() public {
        vm.prank(stranger);
        vm.expectRevert("Not authorized operator");
        registry.recordAssessment(
            TAXPAYER_HASH, RDO_HASH, EXAMINER_HASH, 5000 ether,
            TaxTransparencyRegistry.Category.MSME,
            TaxTransparencyRegistry.Submitter.BIR_OPERATOR,
            keccak256("fake")
        );
    }

    function testOperatorCanFileBIRAssessment() public {
        bytes32 id = _fileBIRAssessment(5000 ether, TaxTransparencyRegistry.Category.MSME);

        TaxTransparencyRegistry.Assessment memory a = registry.getAssessment(id);
        assertEq(a.recordedBy, operator);
        assertEq(uint8(a.submitter), uint8(TaxTransparencyRegistry.Submitter.BIR_OPERATOR));
    }

    function testBothSidesReductionRatesVisible() public {
        // BIR files assessment of 5000
        bytes32 id = _fileBIRAssessment(5000 ether, TaxTransparencyRegistry.Category.MSME);

        // BIR claims they reduced by 500 (10%)
        vm.prank(operator);
        registry.recordReduction(
            id, 500 ether,
            TaxTransparencyRegistry.ReductionReason.NEGOTIATED,
            keccak256("bir-memo")
        );

        // Taxpayer claims the BIR actually knocked it down by 4000 (80%)
        vm.prank(taxpayer);
        registry.recordReduction(
            id, 4000 ether,
            TaxTransparencyRegistry.ReductionReason.NEGOTIATED,
            keccak256("tp-screenshot")
        );

        // Both versions are recorded, side-by-side
        bytes32[] memory reds = registry.getReductionsForAssessment(id);
        assertEq(reds.length, 2);

        // Aggregate rates are split by submitter
        uint256 birRate = registry.getRDOReductionRate(
            RDO_HASH, TaxTransparencyRegistry.Submitter.BIR_OPERATOR
        );
        uint256 tpRate = registry.getRDOReductionRate(
            RDO_HASH, TaxTransparencyRegistry.Submitter.TAXPAYER
        );

        // BIR says 10%, taxpayer says 80%. The gap is the signal.
        assertEq(birRate, 1000);
        assertEq(tpRate, 8000);
    }

    function testReductionCannotExceedAssessment() public {
        bytes32 id = _fileBIRAssessment(1000 ether, TaxTransparencyRegistry.Category.MSME);

        vm.prank(taxpayer);
        vm.expectRevert("Reduction exceeds assessment");
        registry.recordReduction(
            id, 1001 ether,
            TaxTransparencyRegistry.ReductionReason.NEGOTIATED,
            keccak256("x")
        );
    }

    function testPaymentAttachesToAssessment() public {
        bytes32 id = _fileBIRAssessment(5000 ether, TaxTransparencyRegistry.Category.MSME);

        vm.prank(taxpayer);
        bytes32 payId = registry.recordPayment(
            id, TAXPAYER_HASH, 5000 ether, keccak256("receipt")
        );

        TaxTransparencyRegistry.Payment memory p = registry.getPayment(payId);
        assertEq(p.amount, 5000 ether);
        assertEq(p.assessmentId, id);

        bytes32[] memory payments = registry.getPaymentsForAssessment(id);
        assertEq(payments.length, 1);
    }

    function testAdvancePaymentWithoutAssessment() public {
        vm.prank(taxpayer);
        registry.recordPayment(
            bytes32(0), TAXPAYER_HASH, 100 ether, keccak256("advance")
        );
        assertEq(registry.totalPaid(), 100 ether);
    }

    function testCategorySplitMSMEvsLarge() public {
        // Two MSME assessments with heavy reductions
        bytes32 id1 = _fileBIRAssessment(100 ether, TaxTransparencyRegistry.Category.MSME);
        bytes32 id2 = _fileBIRAssessment(200 ether, TaxTransparencyRegistry.Category.MSME);

        vm.prank(operator);
        registry.recordReduction(id1, 80 ether,
            TaxTransparencyRegistry.ReductionReason.NEGOTIATED, keccak256("r1"));
        vm.prank(operator);
        registry.recordReduction(id2, 160 ether,
            TaxTransparencyRegistry.ReductionReason.NEGOTIATED, keccak256("r2"));

        // One large assessment with low reduction
        bytes32 id3 = _fileBIRAssessment(10000 ether, TaxTransparencyRegistry.Category.LARGE);

        vm.prank(operator);
        registry.recordReduction(id3, 200 ether,
            TaxTransparencyRegistry.ReductionReason.NEGOTIATED, keccak256("r3"));

        uint256 msmeRate = registry.getCategoryReductionRate(
            TaxTransparencyRegistry.Category.MSME,
            TaxTransparencyRegistry.Submitter.BIR_OPERATOR
        );
        uint256 largeRate = registry.getCategoryReductionRate(
            TaxTransparencyRegistry.Category.LARGE,
            TaxTransparencyRegistry.Submitter.BIR_OPERATOR
        );

        // MSME: (80+160)/(100+200) = 240/300 = 80%
        assertEq(msmeRate, 8000);
        // Large: 200/10000 = 2%
        assertEq(largeRate, 200);
    }

    function testRDOComparison() public {
        // RDO-039 has a high reduction pattern
        bytes32 idA = _fileBIRAssessment(100 ether, TaxTransparencyRegistry.Category.MSME);
        vm.prank(operator);
        registry.recordReduction(idA, 80 ether,
            TaxTransparencyRegistry.ReductionReason.NEGOTIATED, keccak256("a"));

        // RDO-001 has a low reduction pattern
        vm.prank(operator);
        bytes32 idB = registry.recordAssessment(
            TAXPAYER_HASH, RDO_OTHER, EXAMINER_HASH, 100 ether,
            TaxTransparencyRegistry.Category.MSME,
            TaxTransparencyRegistry.Submitter.BIR_OPERATOR, keccak256("b")
        );
        vm.prank(operator);
        registry.recordReduction(idB, 5 ether,
            TaxTransparencyRegistry.ReductionReason.NEGOTIATED, keccak256("b2"));

        uint256 rate39 = registry.getRDOReductionRate(
            RDO_HASH, TaxTransparencyRegistry.Submitter.BIR_OPERATOR
        );
        uint256 rate01 = registry.getRDOReductionRate(
            RDO_OTHER, TaxTransparencyRegistry.Submitter.BIR_OPERATOR
        );

        assertEq(rate39, 8000);
        assertEq(rate01, 500);
    }

    function testCannotRecordZeroAmount() public {
        vm.prank(taxpayer);
        vm.expectRevert("amount=0");
        registry.recordAssessment(
            TAXPAYER_HASH, RDO_HASH, EXAMINER_HASH, 0,
            TaxTransparencyRegistry.Category.MSME,
            TaxTransparencyRegistry.Submitter.TAXPAYER, keccak256("x")
        );
    }

    function testCannotRecordZeroHashes() public {
        vm.prank(taxpayer);
        vm.expectRevert("taxpayerHash=0");
        registry.recordAssessment(
            bytes32(0), RDO_HASH, EXAMINER_HASH, 1,
            TaxTransparencyRegistry.Category.MSME,
            TaxTransparencyRegistry.Submitter.TAXPAYER, keccak256("x")
        );
    }

    function testReductionOnMissingAssessmentReverts() public {
        vm.prank(taxpayer);
        vm.expectRevert("Assessment not found");
        registry.recordReduction(
            keccak256("nonexistent"), 1 ether,
            TaxTransparencyRegistry.ReductionReason.NEGOTIATED, keccak256("x")
        );
    }

    function testTotals() public {
        _fileBIRAssessment(1000 ether, TaxTransparencyRegistry.Category.MSME);
        assertEq(registry.totalAssessed(), 1000 ether);

        bytes32 id = _fileBIRAssessment(500 ether, TaxTransparencyRegistry.Category.LARGE);
        assertEq(registry.totalAssessed(), 1500 ether);

        vm.prank(taxpayer);
        registry.recordPayment(id, TAXPAYER_HASH, 500 ether, keccak256("p"));
        assertEq(registry.totalPaid(), 500 ether);

        vm.prank(operator);
        registry.recordReduction(id, 100 ether,
            TaxTransparencyRegistry.ReductionReason.NEGOTIATED, keccak256("r"));
        assertEq(registry.totalReduced(), 100 ether);
    }
}

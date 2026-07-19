// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "forge-std/Test.sol";
import "../contracts/AcademicAccreditationSAROracle.sol";

contract AcademicAccreditationSAROracleTest is Test {
    AcademicAccreditationSAROracle oracle;
    address contractor = address(this); // default sovereignContractor sa constructor

    function setUp() public {
        oracle = new AcademicAccreditationSAROracle();
    }

    function testProcessAccreditationSuccess() public {
        uint256 id = oracle.processProgramAccreditationSAR(
            "Tier-I",
            80,   // CO score
            85,   // PO score
            keccak256("evidence")
        );
        // check na may report na na-log
        (uint256 rid, string memory tier, uint256 coScore, uint256 poScore, bool accredited) = oracle.reports(id);
        assertEq(rid, id);
        assertEq(tier, "Tier-I");
        assertEq(coScore, 80);
        assertEq(poScore, 85);
        assertTrue(accredited);
    }

    function testRevertOnLowCOScore() public {
        vm.expectRevert(); // dahil <70% floor
        oracle.processProgramAccreditationSAR(
            "Tier-I",
            60,
            80,
            keccak256("badEvidence")
        );
    }

    function testRevertOnInvalidPercentages() public {
        vm.expectRevert(); // >100% invalid
        oracle.processProgramAccreditationSAR(
            "Tier-I",
            120,
            90,
            keccak256("invalid")
        );
    }

    function testOnlyContractorCanProcess() public {
        vm.prank(address(0xBEEF));
        vm.expectRevert("Error: Only Sovereign Contractor access.");
        oracle.processProgramAccreditationSAR(
            "Tier-I",
            80,
            85,
            keccak256("evidence")
        );
    }
}

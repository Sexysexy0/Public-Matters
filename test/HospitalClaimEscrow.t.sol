// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/HospitalClaimEscrow.sol";

contract HospitalClaimEscrowTest is Test {
    HospitalClaimEscrow public hospital;

    address public owner = address(this);
    address public patient = makeAddr("patient");
    address public hospitalAddr = makeAddr("hospital");

    function setUp() public {
        hospital = new HospitalClaimEscrow();
        // Fund the hospital contract directly for payouts
        vm.deal(address(hospital), 1 ether);
    }

    function test_SubmitApproveAndPay() public {
        bytes32 diagnosis = keccak256(abi.encodePacked("Flu"));
        uint256 amount = 0.1 ether;

        hospital.submitClaim(patient, hospitalAddr, diagnosis, amount);

        (address pat, address hosp, bytes32 diag, uint256 amt, bool approved, bool paid) = hospital.claims(1);
        assertEq(pat, patient);
        assertEq(hosp, hospitalAddr);
        assertEq(amt, amount);
        assertFalse(approved);
        assertFalse(paid);

        hospital.approveClaim(1);

        uint256 hospitalBalanceBefore = hospitalAddr.balance;
        hospital.payClaim(1);

        assertEq(hospitalAddr.balance - hospitalBalanceBefore, amount);
        (, , , , , paid) = hospital.claims(1);
        assertTrue(paid);
    }
}

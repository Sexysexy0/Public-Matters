// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/HospitalClaimEscrow.sol";

contract MockTrustIntegrator {
    uint256 public lastWeight;

    function logPositiveAction(uint256 _weight) external {
        lastWeight = _weight;
    }
}

contract HospitalClaimEscrowTest is Test {
    HospitalClaimEscrow public hospital;
    MockTrustIntegrator public mockIntegrator;

    address public steward = address(this);
    address public patient = makeAddr("patient");
    address public hospitalAddr = makeAddr("hospital");

    function setUp() public {
        mockIntegrator = new MockTrustIntegrator();
        hospital = new HospitalClaimEscrow(address(mockIntegrator));
        vm.deal(address(hospital), 1 ether);
    }

    function test_SubmitApproveAndPay_UpdatesTrust() public {
        bytes32 diagnosis = keccak256(abi.encodePacked("Flu"));
        uint256 amount = 0.1 ether;

        hospital.submitClaim(patient, hospitalAddr, diagnosis, amount);
        hospital.approveClaim(1);

        uint256 hospitalBalanceBefore = hospitalAddr.balance;
        hospital.payClaim(1);

        assertEq(hospitalAddr.balance - hospitalBalanceBefore, amount);
        assertEq(mockIntegrator.lastWeight(), 20);
    }
}

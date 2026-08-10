// SPDX-License-Identifier: MIT
pragma solidity 0.8.35;

import {Test} from "forge-std/Test.sol";
import {TransientSupplyPassport} from "../src/TransientSupplyPassport.sol";

contract BatchVerifierCaller {
    TransientSupplyPassport public passport;

    constructor(address _passport) {
        passport = TransientSupplyPassport(_passport);
    }

    function executeBatchWorkflow(uint256 batchId, bytes32 batchHash) external returns (bool) {
        passport.setTransientBatchData(batchHash);
        return passport.verifyAndLogBatch(batchId, batchHash);
    }
}

contract TransientSupplyPassportTest is Test {
    TransientSupplyPassport public passport;
    BatchVerifierCaller public workflowCaller;

    function setUp() public {
        passport = new TransientSupplyPassport();
        workflowCaller = new BatchVerifierCaller(address(passport));
    }

    function test_TransientBatchWorkflow() public {
        uint256 batchId = 1001;
        bytes32 batchHash = keccak256(abi.encodePacked("SHIPMENT_MANIFEST_MALOLOS_2026"));

        bool success = workflowCaller.executeBatchWorkflow(batchId, batchHash);
        assertTrue(success);
    }

    function test_TransientDataStartsEmptyInNewTx() public {
        // Verify transient storage is uninitialized (0x0) at transaction start
        (bytes32 hashBefore, address inspectorBefore) = passport.getTransientBatchData();
        assertEq(hashBefore, bytes32(0));
        assertEq(inspectorBefore, address(0));

        uint256 batchId = 1002;
        bytes32 batchHash = keccak256(abi.encodePacked("GRAIN_SUPPLY_CALUMPIT_2026"));

        bool success = workflowCaller.executeBatchWorkflow(batchId, batchHash);
        assertTrue(success);
    }
}

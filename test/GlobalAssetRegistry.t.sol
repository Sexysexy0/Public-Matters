// SPDX-License-Identifier: MIT
pragma solidity 0.8.35;

import {Test} from "forge-std/Test.sol";
import {GlobalAssetRegistry} from "../src/GlobalAssetRegistry.sol";

contract MockTarget {
    bool public executed;

    function executeAction() external {
        executed = true;
    }
}

contract GlobalAssetRegistryTest is Test {
    GlobalAssetRegistry public registry;
    MockTarget public target;

    bytes32 public constant ASSET_1 = keccak256("REAL_ESTATE_MANILA");
    address public steward = address(0x1111);
    address public auditor = address(0x2222);

    function setUp() public {
        registry = new GlobalAssetRegistry();
        target = new MockTarget();

        // Register Auditor role via Bitmaps (ROLE_AUDITOR = 4)
        registry.setEntityRoles(auditor, registry.ROLE_AUDITOR());

        // Initialize Brick with approval threshold = 2
        registry.initializeAssetBrick(
            ASSET_1,
            GlobalAssetRegistry.AssetType.RealEstate,
            608, // Philippines country code
            steward,
            2, // Threshold
            1_000_000
        );
    }

    function test_TransientMultiSigFlow() public {
        // Step 1: Approver 1 (Deployer/Emperor) votes
        registry.recordTransientApproval(ASSET_1);
        assertEq(registry.getTransientApprovals(ASSET_1), 1);

        // Step 2: Approver 2 (Auditor) votes
        vm.prank(auditor);
        registry.recordTransientApproval(ASSET_1);
        assertEq(registry.getTransientApprovals(ASSET_1), 2);

        // Step 3: Validate and Execute Target Payload in same transaction execution
        bytes memory payload = abi.encodeWithSignature("executeAction()");
        bool ok = registry.validateAndExecute(ASSET_1, address(target), payload);

        assertTrue(ok);
        assertTrue(target.executed());
    }
}

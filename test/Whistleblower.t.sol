// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.35;

import {Test} from "forge-std/Test.sol";
import {AntiCorruptionWhistleblowerVault} from "../src/AntiCorruptionWhistleblowerVault.sol";

contract AntiCorruptionWhistleblowerVaultTest is Test {
    AntiCorruptionWhistleblowerVault vault;
    address owner = address(this);
    address user = address(0x123);

    function setUp() public {
        vault = new AntiCorruptionWhistleblowerVault();
    }

    function testSubmitProof() public {
        bytes32 bundleId = keccak256("BUNDLE_01");
        bytes32 merkleRoot = keccak256("MERKLE_ROOT_HASH");

        vm.prank(user);
        vault.submitProof(bundleId, merkleRoot);

        (bytes32 storedRoot, uint256 timestamp, bool isLocked) = vault.vault(bundleId);
        
        assertEq(storedRoot, merkleRoot);
        assertGt(timestamp, 0);
        assertEq(isLocked, false);
    }

    function testLockProof() public {
        bytes32 bundleId = keccak256("BUNDLE_02");
        bytes32 merkleRoot = keccak256("MERKLE_ROOT_HASH_2");

        vault.submitProof(bundleId, merkleRoot);
        vault.lockProof(bundleId);

        (,, bool isLocked) = vault.vault(bundleId);
        assertEq(isLocked, true);
    }
}

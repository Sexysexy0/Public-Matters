// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/GameUtilityAndAuditRegistry.sol";

contract GameUtilityAndAuditRegistryTest is Test {
    GameUtilityAndAuditRegistry public registry;

    address owner = address(1);
    address developer = address(2);

    function setUp() public {
        vm.prank(owner);
        registry = new GameUtilityAndAuditRegistry();
    }

    function test_LogInternalUtility() public {
        vm.prank(developer);
        bytes32 proof = keccak256("economy_simulation_v1_results");
        bytes32 recId = registry.logInternalUtility(
            keccak256("sim_run_001"),
            GameUtilityAndAuditRegistry.UtilityType.BalanceSimulation,
            proof
        );

        (bytes32 id, GameUtilityAndAuditRegistry.UtilityType uType, bytes32 pHash, , address rep) = registry.utilityRecords(recId);
        
        assertEq(id, recId);
        assertTrue(uType == GameUtilityAndAuditRegistry.UtilityType.BalanceSimulation);
        assertEq(pHash, proof);
        assertEq(rep, developer);
    }

    function test_AttestHumanCraft() public {
        bytes32 assetId = keccak256("hero_character_art");
        bytes32 sigHash = keccak256("lead_artist_sig");

        vm.prank(owner);
        registry.attestHumanCraft(assetId, "Character Art", sigHash);

        (, string memory cat, bytes32 sig, bool isHuman, ) = registry.craftAttestations(assetId);
        assertEq(cat, "Character Art");
        assertEq(sig, sigHash);
        assertTrue(isHuman);
    }

    function test_RevertWhen_NonOwnerAttestsCraft() public {
        bytes32 assetId = keccak256("soundtrack");
        
        vm.prank(developer);
        vm.expectRevert("Unauthorized: Owner only");
        registry.attestHumanCraft(assetId, "Audio Score", keccak256("sig"));
    }
}

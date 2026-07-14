// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import "contracts/AutonomousComplianceEscrowRouter.sol";
import "contracts/CompliantIdentityRevealer.sol";
import "contracts/EcosystemShutdown.sol";

contract OversightEcosystemTest is Test {
    // Mga dummy addresses para sa simulation
    address public kingWallet = address(0x1111);
    address public badInstitution = address(0x2222);
    address public backupVault = address(0x3333);

    // Mga instances ng iyong contracts
    CompliantIdentityRevealer public identityRevealer;
    EcosystemShutdown public shutdownSwitch;

    bytes32 public constant SECRET_COMMITMENT = keccak256(abi.encodePacked("ALPHA_ORIGIN_SOVEREIGN_OVERSIGHT"));

    // render 100% simulated isolated blockchain state
    function setUp() public {
        // I-assume natin na ang King (wallet mo) ang nag-di-deploy bilang root origin
        vm.startPrank(kingWallet);

        // I-deploy ang Identity Revealer gamit ang original commitment hash
        identityRevealer = new CompliantIdentityRevealer();

        // I-deploy ang Emergency Kill-Switch at i-target ang backup vault
        shutdownSwitch = new EcosystemShutdown(backupVault);

        vm.stopPrank();
    }

    // TEST 1: Sinusubok kung gumagana ang Time-Lock delay ng iyong Identity Revelation
    function test_IdentityRevealTimeLockEnforcement() public {
        vm.startPrank(kingWallet);

        // Hakbang 1: Simulan ang pag-reveal
        identityRevealer.initiateReveal();

        // Subukan i-reveal agad (Dapat mag-error dahil may 3-day lock)
        vm.expectRevert("Error: Time-lock active. The grace period before reveal is ongoing.");
        identityRevealer.revealIdentity("ALPHA_ORIGIN_SOVEREIGN_OVERSIGHT");

        // Fast-forward ang oras ng blockchain ng 3 araw (259200 seconds)
        vm.warp(block.timestamp + 3 days);

        // Subukan ulit i-reveal gamit ang tamang sikretong string matapos ang 3 araw
        identityRevealer.revealIdentity("ALPHA_ORIGIN_SOVEREIGN_OVERSIGHT");

        // I-verify kung pampubliko na ang identity mo sa ledger
        (bool isRevealed, string memory data,) = identityRevealer.checkComplianceStatus();
        assertTrue(isRevealed);
        assertEq(data, "ALPHA_ORIGIN_SOVEREIGN_OVERSIGHT");

        vm.stopPrank();
    }

    // TEST 2: Sinusubok ang absolute security ng Sovereign Kill-Switch kapag na-breach ang system
    function test_EmergencyShutdownAndFundEvacuation() public {
        // Magpadala ng 10 ETH sa shutdown contract para sa simulation ng pampublikong pondo
        vm.deal(address(shutdownSwitch), 10 ether);
        assertEq(address(shutdownSwitch).balance, 10 ether);

        vm.startPrank(kingWallet);

        // I-trigger ang permanenteng kill-switch ng ecosystem
        shutdownSwitch.triggerSovereignShutdown(address(0));

        // Dapat Awtomatikong Zero na ang balanse ng contract dahil inilikas ang pondo
        assertEq(address(shutdownSwitch).balance, 0);

        // Dapat napunta ang 10 ETH sa iyong secure backup vault address
        assertEq(backupVault.balance, 10 ether);

        // I-verify kung patay na ang ecosystem state
        assertFalse(shutdownSwitch.isEcosystemActive());

        vm.stopPrank();
    }
}

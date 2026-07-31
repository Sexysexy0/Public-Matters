// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/GameResaleEscrow.sol";
import "../src/GpuComputeEscrow.sol";
import "../src/IndieGameVault.sol";
import "../src/MandatoryPhysicalDiscRegistry.sol";
import "../src/OfflineRightVault.sol";

contract GamingSuiteTest is Test {
    GameResaleEscrow public resaleEscrow;
    GpuComputeEscrow public gpuEscrow;
    IndieGameVault public indieVault;
    MandatoryPhysicalDiscRegistry public discRegistry;
    OfflineRightVault public offlineVault;

    address public admin = address(this);

    function setUp() public {
        resaleEscrow = new GameResaleEscrow();
        gpuEscrow = new GpuComputeEscrow();
        indieVault = new IndieGameVault(admin);
        discRegistry = new MandatoryPhysicalDiscRegistry();
        offlineVault = new OfflineRightVault("PublicMattersOfflineLicense");
    }

    function test_GamingSuite_Deployments() public view {
        assertTrue(address(resaleEscrow) != address(0));
        assertTrue(address(gpuEscrow) != address(0));
        assertTrue(address(indieVault) != address(0));
        assertTrue(address(discRegistry) != address(0));
        assertTrue(address(offlineVault) != address(0));
    }
}

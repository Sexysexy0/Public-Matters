// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/CCTVTransparencyRegistry.sol";

contract CCTVTransparencyRegistryTest is Test {
    CCTVTransparencyRegistry public registry;

    address public ghostArchitect = address(this);
    address public policeOfficer = makeAddr("policeOfficer");

    function setUp() public {
        registry = new CCTVTransparencyRegistry();
    }

    function test_RegisterAndAccessFlow() public {
        // 1. Register a camera
        bytes32 pubKeyHash = keccak256(abi.encodePacked("PublicKeyXYZ"));
        uint256 camId = registry.registerCamera("Barangay San Juan - Intersection", pubKeyHash);
        
        // FIX: Kunin ang struct at i-access ang fields
        CCTVTransparencyRegistry.Camera memory cam = registry.getCameraInfo(camId);
        assertEq(cam.owner, ghostArchitect);
        assertEq(cam.location, "Barangay San Juan - Intersection");
        assertEq(cam.publicKeyHash, pubKeyHash);
        assertTrue(cam.isActive);

        // 2. Log daily footage hash
        bytes32 footageHash = keccak256(abi.encodePacked("VideoDataForDay1"));
        registry.logDailyFootage(camId, footageHash);

        bytes32 retrievedHash = registry.getFootageHash(camId, 0);
        assertEq(retrievedHash, footageHash);

        // 3. Request access
        vm.prank(policeOfficer);
        registry.requestFootageAccess(camId, 0, "Ongoing investigation - Theft");

        // 4. Approve access (Ghost architect)
        registry.approveAccess(camId, 0);
    }
}

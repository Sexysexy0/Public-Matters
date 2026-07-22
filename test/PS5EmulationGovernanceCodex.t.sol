// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/PS5EmulationGovernanceCodex.sol";

contract PS5EmulationGovernanceCodexTest is Test {
    PS5EmulationGovernanceCodex codex;

    function setUp() public {
        codex = new PS5EmulationGovernanceCodex();
    }

    function testRegisterEmulationSuccess() public {
        uint256 id = codex.registerEmulation("SharpMU", "Preservation", "Early Stage");
        PS5EmulationGovernanceCodex.EmulationProfile memory profile = codex.getEmulation(id);

        assertEq(profile.id, id);
        assertEq(profile.project, "SharpMU");
        assertEq(profile.focus, "Preservation");
        assertEq(profile.status, "Early Stage");
        assertTrue(profile.accredited);
    }

    function testMultipleEmulationsIndependent() public {
        uint256 id1 = codex.registerEmulation("SharpMU", "Preservation", "Early Stage");
        uint256 id2 = codex.registerEmulation("KytyPS5", "Gameplay", "Experimental");

        PS5EmulationGovernanceCodex.EmulationProfile memory p1 = codex.getEmulation(id1);
        PS5EmulationGovernanceCodex.EmulationProfile memory p2 = codex.getEmulation(id2);

        assertEq(p1.project, "SharpMU");
        assertEq(p2.project, "KytyPS5");
        assertEq(p1.focus, "Preservation");
        assertEq(p2.focus, "Gameplay");
    }

    function testOnlyContractorCanRegister() public {
        vm.prank(address(0xBEEF));
        vm.expectRevert("Error: Only Sovereign Contractor access.");
        codex.registerEmulation("FakeEMU", "Fraudulent", "Malware");
    }
}

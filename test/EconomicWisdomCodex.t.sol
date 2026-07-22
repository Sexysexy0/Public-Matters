// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/EconomicWisdomCodex.sol";

contract EconomicWisdomCodexTest is Test {
    EconomicWisdomCodex codex;

    function setUp() public {
        codex = new EconomicWisdomCodex();
    }

    function testRegisterPillarSuccess() public {
        uint256 id = codex.registerPillar("Tanstaafl", "Every choice involves a trade-off");
        EconomicWisdomCodex.Pillar memory pillar = codex.getPillar(id);

        assertEq(pillar.id, id);
        assertEq(pillar.principle, "Tanstaafl");
        assertEq(pillar.description, "Every choice involves a trade-off");
        assertTrue(pillar.accredited);
    }

    function testMultiplePillarsIndependent() public {
        uint256 id1 = codex.registerPillar("Incentives Matter", "Human behavior is driven by incentives");
        uint256 id2 = codex.registerPillar("Marginal Thinking", "Decisions are made on the margin");

        EconomicWisdomCodex.Pillar memory p1 = codex.getPillar(id1);
        EconomicWisdomCodex.Pillar memory p2 = codex.getPillar(id2);

        assertEq(p1.principle, "Incentives Matter");
        assertEq(p2.principle, "Marginal Thinking");
    }

    function testOnlyContractorCanRegister() public {
        vm.prank(address(0xBEEF));
        vm.expectRevert("Error: Only Sovereign Contractor access.");
        codex.registerPillar("Fraudulent", "Invalid principle");
    }
}

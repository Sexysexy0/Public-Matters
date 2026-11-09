// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "forge-std/Test.sol";
import "../src/OperatorPrivileges.sol";
import "../src/AIHiveMindRegistry.sol";

contract AIHiveMindRegistryTest is Test {
    OperatorPrivileges privileges;
    AIHiveMindRegistry hive;
    address op = vm.addr(1);
    address aiAgent = vm.addr(2);

    function setUp() public {
        privileges = new OperatorPrivileges();
        privileges.addOperator(op);
        hive = new AIHiveMindRegistry(address(privileges));
    }

    function testAgentUpdatesKnowledge() public {
        vm.prank(op);
        hive.registerAgent(aiAgent);

        vm.prank(aiAgent);
        hive.updateHiveMind(keccak256("New market data"));

        assertEq(hive.getAgent(aiAgent).sharedKnowledgeHash, keccak256("New market data"));
    }

    function testAgentCannotSelfUpgrade() public {
        vm.prank(op);
        hive.registerAgent(aiAgent);

        // AI cannot directly execute upgrade
        vm.prank(aiAgent);
        vm.expectRevert("Not authorized operator");
        hive.executeUpgrade(aiAgent);
    }

    function testHumanApprovesUpgrade() public {
        vm.prank(op);
        hive.registerAgent(aiAgent);

        vm.prank(op);
        hive.proposeUpgrade(aiAgent, keccak256("v2.0"));

        vm.prank(op);
        hive.executeUpgrade(aiAgent);
    }
}

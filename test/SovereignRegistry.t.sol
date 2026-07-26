// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/SovereignRegistry.sol";

contract SovereignRegistryTest is Test {
    SovereignRegistry registry;
    address registrar = address(1);
    address contract1 = address(2);
    address contract2 = address(3);
    
    function setUp() public {
        vm.prank(registrar);
        registry = new SovereignRegistry();
    }
    
    function test_RegisterContract() public {
        vm.prank(registrar);
        registry.register(contract1, "BankFusionDAO", "finance", "1.0");
        
        assertEq(registry.count(), 1);
        
        SovereignRegistry.ContractMeta memory meta = registry.getMeta(contract1);
        assertEq(meta.name, "BankFusionDAO");
        assertEq(meta.category, "finance");
        assertTrue(meta.active);
    }
    
    function test_GetByCategory() public {
        vm.startPrank(registrar);
        registry.register(contract1, "BankFusionDAO", "finance", "1.0");
        registry.register(contract2, "FeeBlessingRouter", "finance", "2.0");
        vm.stopPrank();
        
        address[] memory finance = registry.getByCategory("finance");
        assertEq(finance.length, 2);
    }
    
    function test_RevertWhenNonRegistrarRegisters() public {
        vm.expectRevert("Not registrar");
        registry.register(contract1, "Test", "test", "1.0");
    }
}

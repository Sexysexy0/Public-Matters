// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/SovereignRegistry.sol";

contract SovereignRegistryTest is Test {
    SovereignRegistry registry;
    address registrar = address(1);
    address contract1 = address(2);
    address contract2 = address(3);
    address contract3 = address(4);
    
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
    
    function test_RegisterBatch() public {
        address[] memory addrs = new address[](2);
        addrs[0] = contract1;
        addrs[1] = contract2;
        
        string[] memory names = new string[](2);
        names[0] = "BankFusionDAO";
        names[1] = "FeeBlessingRouter";
        
        string[] memory cats = new string[](2);
        cats[0] = "finance";
        cats[1] = "finance";
        
        string[] memory vers = new string[](2);
        vers[0] = "1.0";
        vers[1] = "2.0";
        
        vm.prank(registrar);
        registry.registerBatch(addrs, names, cats, vers);
        
        assertEq(registry.count(), 2);
    }
    
    function test_RevertDuplicateName() public {
        vm.startPrank(registrar);
        registry.register(contract1, "BankFusionDAO", "finance", "1.0");
        
        vm.expectRevert("Name taken");
        registry.register(contract2, "BankFusionDAO", "water", "1.0");
        vm.stopPrank();
    }
    
    function test_TransferRegistrar() public {
        address newRegistrar = address(5);
        
        vm.prank(registrar);
        registry.transferRegistrar(newRegistrar);
        
        vm.prank(newRegistrar);
        registry.register(contract1, "Test", "test", "1.0");
        
        assertEq(registry.count(), 1);
    }
}

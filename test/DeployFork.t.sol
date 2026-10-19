// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/BudgetDeliberationRegistry.sol";

contract DeployForkTest is Test {
    function testDeployOnFork() public {
        vm.createSelectFork(vm.envString("ETH_SEPOLIA_RPC"));
        BudgetDeliberationRegistry r = new BudgetDeliberationRegistry(0x1ec4a1fB4e8D297DE39b3995Bcbbd8c5e7fcEF98);
        assertTrue(address(r) != address(0));
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../src/BudgetAuditIntegrator.sol";

contract DeployBudgetAuditIntegrator is Script {
    function run() external {
        uint256 pk = vm.envUint("PRIVATE_KEY");

        address privileges =
            vm.envOr("OPERATOR_PRIVILEGES_V2_ADDRESS", address(0x1ec4a1fB4e8D297DE39b3995Bcbbd8c5e7fcEF98));
        address auditAddr = vm.envOr("AUDIT_ADDRESS", address(0x9E93a6A3421AD0F8F029406aC3Ce3E21e8544074));
        address budgetAddr = vm.envAddress("BUDGET_ADDRESS");

        vm.startBroadcast(pk);
        BudgetAuditIntegrator integrator = new BudgetAuditIntegrator(privileges, auditAddr, budgetAddr);
        vm.stopBroadcast();

        console.log("BudgetAuditIntegrator:", address(integrator));
        console.log("privileges:           ", privileges);
        console.log("audit:                ", auditAddr);
        console.log("budget registry:      ", budgetAddr);
    }
}

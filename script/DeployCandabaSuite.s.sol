// SPDX-License-Identifier: MIT
pragma solidity 0.8.35;

import {Script, console} from "forge-std/Script.sol";
import {OperatorPrivileges} from "../src/OperatorPrivileges.sol";
import {FarmerCompensationVault} from "../src/FarmerCompensationVault.sol";

contract DeployCandabaSuite is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        // 1. Deploy/Locate Core OperatorPrivileges first
        OperatorPrivileges privileges = new OperatorPrivileges();
        console.log("OperatorPrivileges deployed at:", address(privileges));

        // 2. Define Mock NexusID configuration layout
        address nexusID = address(0x9999999999999999999999999999999999999999);

        // 3. Fix: Pass both privileges and nexusID to match the updated contract layout
        FarmerCompensationVault compensationVault = new FarmerCompensationVault(address(privileges), nexusID);
        console.log("FarmerCompensationVault deployed under Candaba Suite at:", address(compensationVault));

        // 4. Authorize module to perform state-changing ledger writes
        privileges.addOperator(address(compensationVault));
        console.log("Candaba Suite module successfully authorized inside core permissions.");

        vm.stopBroadcast();
    }
}

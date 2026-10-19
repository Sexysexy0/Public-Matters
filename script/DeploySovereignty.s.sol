// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../contracts/SovereigntyPolicyRegistry.sol";
import "../contracts/CorporateUBOControl.sol";
import "../contracts/AccessControlGovernance.sol";

contract DeploySovereignty is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        address privileges =
            vm.envOr("OPERATOR_PRIVILEGES_V2_ADDRESS", address(0x1ec4a1fB4e8D297DE39b3995Bcbbd8c5e7fcEF98));

        vm.startBroadcast(deployerPrivateKey);

        SovereigntyPolicyRegistry policyRegistry = new SovereigntyPolicyRegistry(privileges);
        CorporateUBOControl uboControl = new CorporateUBOControl(privileges);
        AccessControlGovernance accessControl = new AccessControlGovernance(privileges);

        console.log("SovereigntyPolicyRegistry deployed at:", address(policyRegistry));
        console.log("CorporateUBOControl deployed at:", address(uboControl));
        console.log("AccessControlGovernance deployed at:", address(accessControl));
        console.log("Bound to OperatorPrivilegesV2:", privileges);

        vm.stopBroadcast();
    }
}

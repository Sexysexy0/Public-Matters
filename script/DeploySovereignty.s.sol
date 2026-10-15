// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Script.sol";
import "../contracts/SovereigntyPolicyRegistry.sol";
import "../contracts/CorporateUBOControl.sol";
import "../contracts/AccessControlGovernance.sol";

contract DeploySovereignty is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        
        vm.startBroadcast(deployerPrivateKey);

        SovereigntyPolicyRegistry policyRegistry = new SovereigntyPolicyRegistry();
        CorporateUBOControl uboControl = new CorporateUBOControl();
        AccessControlGovernance accessControl = new AccessControlGovernance();

        console.log("SovereigntyPolicyRegistry deployed at:", address(policyRegistry));
        console.log("CorporateUBOControl deployed at:", address(uboControl));
        console.log("AccessControlGovernance deployed at:", address(accessControl));

        vm.stopBroadcast();
    }
}

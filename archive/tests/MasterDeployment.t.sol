// SPDX-License-Identifier: MIT
pragma solidity 0.8.35;

import {Test} from "forge-std/Test.sol";
import {DeployMasterArchitecture} from "../script/DeployMasterArchitecture.s.sol";

contract MasterDeploymentTest is Test {
    DeployMasterArchitecture public deployer;

    function setUp() public {
        deployer = new DeployMasterArchitecture();
    }

    function test_MasterDeploymentScript() public {
        deployer.run();
    }
}

// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/InfraCostGovernor.sol";

contract InfraCostGovernorTest is Test {
    InfraCostGovernor governor;

    function setUp() public {
        governor = new InfraCostGovernor();
    }

    function testLogInfraAndFlag() public {
        bytes32 workload = keccak256("API");
        governor.logInfra(workload, 100, 200); // should flag markup
    }
}

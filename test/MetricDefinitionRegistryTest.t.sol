// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/MetricDefinitionRegistry.sol";

contract MetricDefinitionRegistryTest is Test {
    MetricDefinitionRegistry registry;

    function setUp() public {
        registry = new MetricDefinitionRegistry();
    }

    function testDefineMetric() public {
        registry.defineMetric("ARR", "Annual Recurring Revenue definition");
        assertEq(registry.definitions("ARR"), "Annual Recurring Revenue definition");
    }
}

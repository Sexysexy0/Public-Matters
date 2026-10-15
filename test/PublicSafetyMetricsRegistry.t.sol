// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivileges.sol";
import "../src/PublicSafetyMetricsRegistry.sol";

contract PublicSafetyMetricsRegistryTest is Test {
    OperatorPrivileges privileges;
    PublicSafetyMetricsRegistry registry;

    address operator = vm.addr(1);
    address stranger = vm.addr(2);

    bytes32 constant REGION_A = keccak256("region-metro");
    bytes32 constant REGION_B = keccak256("region-province");
    bytes32 constant CAT_VIOLENT = keccak256("category-violent");
    bytes32 constant CAT_TRAFFIC = keccak256("category-traffic");

    function setUp() public {
        privileges = new OperatorPrivileges();
        registry = new PublicSafetyMetricsRegistry(address(privileges));
        privileges.addOperator(operator);
    }

    function _report(bytes32 region, bytes32 category) internal returns (bytes32) {
        vm.prank(operator);
        return registry.reportIncident(region, category, keccak256("evidence"));
    }

    function testReportIncident() public {
        bytes32 id = _report(REGION_A, CAT_VIOLENT);
        PublicSafetyMetricsRegistry.Incident memory i = registry.getIncident(id);
        assertEq(i.regionHash, REGION_A);
        assertEq(i.categoryHash, CAT_VIOLENT);
        assertEq(registry.totalIncidents(), 1);
    }

    function testStrangerCannotReport() public {
        vm.prank(stranger);
        vm.expectRevert("Not authorized operator");
        registry.reportIncident(REGION_A, CAT_VIOLENT, bytes32(0));
    }

    function testCannotReportZeroRegion() public {
        vm.prank(operator);
        vm.expectRevert("regionHash=0");
        registry.reportIncident(bytes32(0), CAT_VIOLENT, bytes32(0));
    }

    function testRecordResponse() public {
        bytes32 id = _report(REGION_A, CAT_VIOLENT);
        skip(120); // 120 seconds

        vm.prank(operator);
        registry.recordResponse(id);

        assertEq(registry.totalResponded(), 1);
        assertEq(registry.getAverageResponseTime(REGION_A), 120);
    }

    function testCannotRespondTwice() public {
        bytes32 id = _report(REGION_A, CAT_VIOLENT);
        vm.prank(operator);
        registry.recordResponse(id);
        vm.prank(operator);
        vm.expectRevert("Already responded");
        registry.recordResponse(id);
    }

    function testRecordResolution() public {
        bytes32 id = _report(REGION_A, CAT_VIOLENT);
        vm.prank(operator);
        registry.recordResolution(id, keccak256("outcome-arrested"));

        PublicSafetyMetricsRegistry.Incident memory i = registry.getIncident(id);
        assertEq(i.outcomeHash, keccak256("outcome-arrested"));
        assertEq(registry.totalResolved(), 1);
    }

    function testCannotResolveWithoutOutcome() public {
        bytes32 id = _report(REGION_A, CAT_VIOLENT);
        vm.prank(operator);
        vm.expectRevert("outcomeHash=0");
        registry.recordResolution(id, bytes32(0));
    }

    function testAverageResponseTimeMulti() public {
        bytes32 id1 = _report(REGION_A, CAT_VIOLENT);
        bytes32 id2 = _report(REGION_A, CAT_VIOLENT);

        skip(100);
        vm.prank(operator);
        registry.recordResponse(id1);

        skip(200);
        vm.prank(operator);
        registry.recordResponse(id2);

        // (100 + 300) / 2 = 200 seconds avg
        // wait: second incident reported at t=0, responded at t=300 -> 300
        // first incident reported at t=0, responded at t=100 -> 100
        // avg = (100 + 300) / 2 = 200
        assertEq(registry.getAverageResponseTime(REGION_A), 200);
    }

    function testRegionStats() public {
        bytes32 id = _report(REGION_A, CAT_VIOLENT);
        vm.prank(operator);
        registry.recordResponse(id);
        vm.prank(operator);
        registry.recordResolution(id, keccak256("o"));

        (uint256 inc, uint256 resp, uint256 res) = registry.getRegionStats(REGION_A);
        assertEq(inc, 1);
        assertEq(resp, 1);
        assertEq(res, 1);
    }

    function testCategoryCount() public {
        _report(REGION_A, CAT_VIOLENT);
        _report(REGION_A, CAT_VIOLENT);
        _report(REGION_B, CAT_TRAFFIC);

        assertEq(registry.getCategoryCount(CAT_VIOLENT), 2);
        assertEq(registry.getCategoryCount(CAT_TRAFFIC), 1);
    }

    function testTotals() public {
        bytes32 id = _report(REGION_A, CAT_VIOLENT);
        vm.startPrank(operator);
        registry.recordResponse(id);
        registry.recordResolution(id, keccak256("o"));
        vm.stopPrank();

        (uint256 inc, uint256 resp, uint256 res) = registry.getTotals();
        assertEq(inc, 1);
        assertEq(resp, 1);
        assertEq(res, 1);
    }
}

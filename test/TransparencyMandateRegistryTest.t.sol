// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/TransparencyMandateRegistry.sol";

contract TransparencyMandateRegistryTest is Test {
    TransparencyMandateRegistry registry;

    function setUp() public {
        registry = new TransparencyMandateRegistry();
    }

    function testFileProjectEmitsEvent() public {
        bytes32 id = keccak256("GenericProject");
        vm.expectEmit(true, true, true, true);
        emit TransparencyMandateRegistry.ProjectFiled(
            id, address(0x1234), "Generic Governance Project", "Test description", "Governance"
        );
        registry.fileProject(id, address(0x1234), "Generic Governance Project", "Test description", "Governance");
    }

    function testFileHumanPreservationCovenantEmitsEvent() public {
        bytes32 id = keccak256("BillOfHumanPreservation");
        vm.expectEmit(true, true, true, true);
        emit TransparencyMandateRegistry.ProjectFiled(
            id,
            address(0x5678),
            "Bill of Human Preservation Covenant",
            "Humanity first, Living things next, System last",
            "HumanPreservation"
        );
        registry.fileHumanPreservationCovenant(
            id,
            address(0x5678),
            "Bill of Human Preservation Covenant",
            "Humanity first, Living things next, System last"
        );
    }

    function testGetProjectReturnsCorrectData() public {
        bytes32 id = keccak256("BillOfHumanPreservation");
        registry.fileHumanPreservationCovenant(
            id,
            address(0x5678),
            "Bill of Human Preservation Covenant",
            "Humanity first, Living things next, System last"
        );
        TransparencyMandateRegistry.Project memory project = registry.getProject(id);
        assertEq(project.contractAddress, address(0x5678));
        assertEq(project.category, "HumanPreservation");
    }

    function testListProjectsContainsFiledIds() public {
        bytes32 id1 = keccak256("GenericProject");
        bytes32 id2 = keccak256("BillOfHumanPreservation");
        registry.fileProject(id1, address(0x1111), "Generic", "Desc", "Governance");
        registry.fileHumanPreservationCovenant(id2, address(0x2222), "Bill", "Desc");
        bytes32[] memory ids = registry.listProjects();
        assertEq(ids.length, 2);
        assertEq(ids[0], id1);
        assertEq(ids[1], id2);
    }

    function testCannotFileDuplicateProject() public {
        bytes32 id = keccak256("DuplicateProject");
        registry.fileProject(id, address(0x3333), "Dup", "Desc", "Governance");
        vm.expectRevert("Project already exists");
        registry.fileProject(id, address(0x4444), "Dup2", "Desc2", "Governance");
    }
}

// SPDX-License-Identifier: MIT
pragma solidity 0.8.35;

import {Test} from "forge-std/Test.sol";
import {ZKWhistleblowerOversight} from "../src/ZKWhistleblowerOversight.sol";

contract ZKWhistleblowerOversightTest is Test {
    ZKWhistleblowerOversight public vault;

    bytes32 public leaf1;
    bytes32 public leaf2;
    bytes32 public root;

    function setUp() public {
        leaf1 = keccak256(abi.encodePacked("CLEARANCE_AGENT_001"));
        leaf2 = keccak256(abi.encodePacked("CLEARANCE_AGENT_002"));

        if (leaf1 <= leaf2) {
            root = keccak256(abi.encodePacked(leaf1, leaf2));
        } else {
            root = keccak256(abi.encodePacked(leaf2, leaf1));
        }

        vault = new ZKWhistleblowerOversight(root);
    }

    function test_SubmitAnonymousReportWithProof() public {
        bytes32 evidenceHash = keccak256(abi.encodePacked("CLASSIFIED_INFRA_AUDIT_2026"));

        bytes32[] memory proof = new bytes32[](1);
        proof[0] = leaf2;

        uint256 reportId = vault.submitAnonymousReport(evidenceHash, leaf1, proof);
        assertEq(reportId, 1);
    }
}

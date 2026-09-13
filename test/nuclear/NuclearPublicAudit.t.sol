// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

import {Test} from "forge-std/Test.sol";
import {NuclearPublicAudit} from "../../src/NuclearPublicAudit.sol";

contract NuclearPublicAuditTest is Test {
    NuclearPublicAudit audit;

    address auditor = address(0xBEEF);
    address outsider = address(0xCAFE);

    bytes32 constant SUBJECT = keccak256("G0 decision");
    bytes32 constant ACTION = keccak256("gate-approved");
    bytes32 constant PAYLOAD = keccak256("payload-1");
    bytes32 constant ENTRY_ID = keccak256("entry-1");
    bytes32 constant REPLACEMENT_ID = keccak256("entry-2");

    function setUp() public {
        audit = new NuclearPublicAudit();
        audit.setAuditor(auditor, true);
    }

    function testLogEntry() public {
        vm.prank(auditor);
        audit.logEntry(ENTRY_ID, SUBJECT, ACTION, PAYLOAD);

        NuclearPublicAudit.AuditEntry memory entry = audit.getEntry(ENTRY_ID);

        assertEq(entry.subject, SUBJECT);
        assertEq(entry.action, ACTION);
        assertEq(entry.payloadHash, PAYLOAD);
        assertEq(entry.actor, auditor);
        assertFalse(entry.frozen);
    }

    function testUnauthorizedAuditorBlocked() public {
        vm.expectRevert(NuclearPublicAudit.Unauthorized.selector);
        vm.prank(outsider);
        audit.logEntry(ENTRY_ID, SUBJECT, ACTION, PAYLOAD);
    }

    function testDuplicateEntryBlocked() public {
        vm.startPrank(auditor);
        audit.logEntry(ENTRY_ID, SUBJECT, ACTION, PAYLOAD);

        vm.expectRevert(NuclearPublicAudit.AlreadyExists.selector);
        audit.logEntry(ENTRY_ID, SUBJECT, ACTION, PAYLOAD);
        vm.stopPrank();
    }

    function testChainLinksToPreviousEntry() public {
        vm.startPrank(auditor);
        audit.logEntry(ENTRY_ID, SUBJECT, ACTION, PAYLOAD);
        audit.logEntry(REPLACEMENT_ID, SUBJECT, keccak256("gate-conditional"), keccak256("payload-2"));
        vm.stopPrank();

        NuclearPublicAudit.AuditEntry memory previous = audit.getEntry(ENTRY_ID);
        NuclearPublicAudit.AuditEntry memory current = audit.getEntry(REPLACEMENT_ID);

        assertEq(previous.previousEntryHash, bytes32(0));
        assertTrue(current.previousEntryHash != bytes32(0));
        assertEq(audit.latestEntryBySubject(SUBJECT), REPLACEMENT_ID);
    }

    function testFreezeEntry() public {
        vm.prank(auditor);
        audit.logEntry(ENTRY_ID, SUBJECT, ACTION, PAYLOAD);

        audit.freezeEntry(ENTRY_ID);

        NuclearPublicAudit.AuditEntry memory entry = audit.getEntry(ENTRY_ID);
        assertTrue(entry.frozen);
    }

    function testFrozenEntryCannotBeSuperseded() public {
        vm.prank(auditor);
        audit.logEntry(ENTRY_ID, SUBJECT, ACTION, PAYLOAD);

        audit.freezeEntry(ENTRY_ID);

        vm.expectRevert(NuclearPublicAudit.FrozenEntry.selector);
        vm.prank(auditor);
        audit.supersedeEntry(ENTRY_ID, REPLACEMENT_ID, keccak256("correction"), keccak256("payload-2"));
    }

    function testSupersedeEntry() public {
        vm.prank(auditor);
        audit.logEntry(ENTRY_ID, SUBJECT, ACTION, PAYLOAD);

        vm.prank(auditor);
        audit.supersedeEntry(ENTRY_ID, REPLACEMENT_ID, keccak256("correction"), keccak256("payload-2"));

        assertTrue(audit.entryExists(REPLACEMENT_ID));
        assertEq(audit.latestEntryBySubject(SUBJECT), REPLACEMENT_ID);
    }
}

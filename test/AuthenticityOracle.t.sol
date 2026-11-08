// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivileges.sol";
import "../src/AuthenticityOracle.sol";

contract AuthenticityOracleTest is Test {
    OperatorPrivileges privileges;
    AuthenticityOracle oracle;

    address op = vm.addr(1);
    address creator = vm.addr(2);
    address clone = vm.addr(3);

    bytes32 constant GAME_HASH = keccak256("Word Play Game Build v1.0");
    bytes32 constant METADATA_HASH = keccak256("ipfs://QmMetadata...");

    function setUp() public {
        privileges = new OperatorPrivileges();
        privileges.addOperator(op);
        
        oracle = new AuthenticityOracle(address(privileges));
    }

    function testRegisterWork() public {
        vm.prank(creator);
        oracle.registerWork(GAME_HASH, METADATA_HASH);

        AuthenticityOracle.Work memory w = oracle.getWork(GAME_HASH);
        assertEq(w.creator, creator);
        assertEq(w.metadataHash, METADATA_HASH);
        assertFalse(w.verified);
    }

    function testCannotCloneOriginalHash() public {
        // Original creator registers
        vm.prank(creator);
        oracle.registerWork(GAME_HASH, METADATA_HASH);

        // AI clone tries to register the exact same build
        vm.prank(clone);
        vm.expectRevert("Work already registered");
        oracle.registerWork(GAME_HASH, keccak256("fake metadata"));
    }

    function testOperatorVerifiesWork() public {
        vm.prank(creator);
        oracle.registerWork(GAME_HASH, METADATA_HASH);

        vm.prank(op);
        oracle.verifyWork(GAME_HASH);

        AuthenticityOracle.Work memory w = oracle.getWork(GAME_HASH);
        assertTrue(w.verified);
    }

    function testStrangerCannotVerify() public {
        vm.prank(creator);
        oracle.registerWork(GAME_HASH, METADATA_HASH);

        vm.prank(clone);
        vm.expectRevert("Not authorized operator");
        oracle.verifyWork(GAME_HASH);
    }
}

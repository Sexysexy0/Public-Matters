// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/HashRegistry.sol";

contract HashRegistryTest is Test {
    HashRegistry registry;

    function setUp() public {
        registry = new HashRegistry();
    }

    function testRegisterEmitsEvent() public {
        bytes32 docHash = keccak256(abi.encodePacked("example-doc"));
        vm.expectEmit(true, true, false, true);
        emit HashRegistry.DocumentRegistered(docHash, address(this), block.timestamp, "TEST");
        registry.register(docHash, "TEST");
    }

    // helper to assert event signature (optional)
    event DocumentRegistered(bytes32 indexed docHash, address indexed registrar, uint256 timestamp, string tag);
}

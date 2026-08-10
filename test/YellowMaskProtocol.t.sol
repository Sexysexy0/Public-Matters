// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/YellowMaskProtocol.sol";

contract YellowMaskProtocolTest is Test {
    YellowMaskProtocol mask;

    function setUp() public {
        mask = new YellowMaskProtocol();
    }

    function test_AddMask() public {
        uint256 id = mask.addMask("Cosmic horror archetype");
        assertEq(id, 1);
        (uint256 storedId, address submitter,,) = mask.masks(id);
        assertEq(storedId, 1);
        assertEq(submitter, address(this));
    }
}

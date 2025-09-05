// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import {SignalBlessingRouter} from "../../contracts/router/SignalBlessingRouter.sol";

contract SignalBlessingRouterTest is Test {
    SignalBlessingRouter router;
    address receiver;

    function setUp() public {
        router = new SignalBlessingRouter();
        receiver = address(0xB4A5); // mock verified receiver
        router.verifyReceiver(receiver);
    }

    function testBlessSignal() public {
        bytes32 signalId = keccak256(abi.encodePacked("TarotFeed", block.timestamp));
        router.blessSignal(signalId, receiver);
        assertTrue(router.isBlessed(signalId));
    }
}

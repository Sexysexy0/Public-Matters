// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/SovereignTransitProtocol.sol";

contract SovereignTransitProtocolTest is Test {
    SovereignTransitProtocol public transit;
    address public osg = address(this);
    address public operator = address(0x111);
    address public driver = address(0x222);
    address public commuter = address(0x333);

    function setUp() public {
        transit = new SovereignTransitProtocol();
        transit.registerOperator(operator);
        transit.registerDriver(driver, operator);
    }

    function testFareSplitAndStrike() public {
        vm.deal(commuter, 1000 wei);

        // Step 1: Commuter pays 100 wei for the ride
        vm.prank(commuter);
        transit.payFare{value: 100 wei}(driver);

        // Step 2: Verify the 80/20 split!
        assertEq(driver.balance, 80 wei); // 80% to Driver
        assertEq(operator.balance, 20 wei); // 20% to Operator

        // Step 3: OSG drops the hammer (3 Strikes)
        transit.penalizeOperator(operator);
        transit.penalizeOperator(operator);
        transit.penalizeOperator(operator);

        // Step 4: Commuter tries to pay again, should fail because franchise is revoked
        vm.prank(commuter);
        vm.expectRevert("Operator suspended");
        transit.payFare{value: 100 wei}(driver);
    }
}

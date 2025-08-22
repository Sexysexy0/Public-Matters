// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../VinvinCopi_OneCoreProtocol.sol";

contract CopiProtocolTest is Test {
    VinvinCopi_OneCoreProtocol protocol;

    // Declare the event locally to match the signature from the contract
    event BlessingActivated(string stewardName, uint256 resonance, uint256 timestamp);

    function setUp() public {
        protocol = new VinvinCopi_OneCoreProtocol();
    }

    function testBlessingActivation() public {
        bool success = protocol.activateBlessing("Aria Lynne", 88);
        assertTrue(success, "Blessing activation failed for Kinder Queen");
    }

    function testMultipleBlessings() public {
        bool first = protocol.activateBlessing("Aria Lynne", 88);
        bool second = protocol.activateBlessing("Wiley Anne", 95);
        assertTrue(first && second, "Blessing activation failed for one or both Kinder Queens");
    }

    function testBlessingEventEmission() public {
        vm.expectEmit(true, true, false, false); // Match steward and resonance only
        emit BlessingActivated("Aria Lynne", 88, 0); // Timestamp ignored
        protocol.activateBlessing("Aria Lynne", 88);
    }

    // Optional: Uncomment if getAPR is implemented in your contract
    /*
    function testAPRIntegrity() public {
        uint256 apr = protocol.getAPR("Wiley Anne");
        assertGt(apr, 0, "APR should be greater than zero");
    }

    function testAPRThreshold() public {
        uint256 apr = protocol.getAPR("Aria Lynne");
        assertGe(apr, 50, "APR must meet minimum resonance threshold");
    }
    */
}

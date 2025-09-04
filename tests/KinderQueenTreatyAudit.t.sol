// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../contracts/KinderQueenTreatyKit.sol";

contract KinderQueenTreatyAudit is Test {
    KinderQueenTreatyKit treatyKit;

    function setUp() public {
        treatyKit = new KinderQueenTreatyKit();
    }

    function testDeclareTreaty() public {
        treatyKit.declareTreaty("KinderQueen:Health", "Pediatric care and emotional safety");
        (string memory tag, string memory desc, uint256 timestamp) = treatyKit.getTreaty(0);
        assertEq(tag, "KinderQueen:Health");
        assertEq(desc, "Pediatric care and emotional safety");
        assertGt(timestamp, 0);
    }

    function testMultipleTreaties() public {
        treatyKit.declareTreaty("KinderQueen:Education", "Scroll-certified early learning");
        treatyKit.declareTreaty("KinderQueen:Housing", "Safe shelters and ancestral sanctums");
        assertEq(treatyKit.totalTreaties(), 2);
    }

    function testTreatyTimestampIntegrity() public {
        treatyKit.declareTreaty("KinderQueen:Infrastructure", "Mythic bridges and barangay grids");
        (, , uint256 timestamp) = treatyKit.getTreaty(0);
        assertGt(timestamp, 0);
    }
}

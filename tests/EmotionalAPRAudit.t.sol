// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../contracts/EmotionalAPROracle.sol";

contract EmotionalAPRAudit is Test {
    EmotionalAPROracle oracle;

    function setUp() public {
        oracle = new EmotionalAPROracle();
    }

    function testTagSector() public {
        oracle.tagSector("Health", 92, 88, 95);
        EmotionalAPROracle.APRTag memory tag = oracle.getTag(0);
        assertEq(tag.sector, "Health");
        assertEq(tag.empathy, 92);
        assertEq(tag.trust, 88);
        assertEq(tag.clarity, 95);
    }

    function testMultipleTags() public {
        oracle.tagSector("Education", 85, 90, 93);
        oracle.tagSector("Housing", 95, 90, 94);
        EmotionalAPROracle.APRTag memory tag1 = oracle.getTag(0);
        EmotionalAPROracle.APRTag memory tag2 = oracle.getTag(1);
        assertEq(tag1.sector, "Education");
        assertEq(tag2.sector, "Housing");
    }

    function testTotalTags() public {
        oracle.tagSector("Infrastructure", 78, 82, 80);
        oracle.tagSector("Transport", 81, 79, 85);
        assertEq(oracle.totalTags(), 2);
    }
}

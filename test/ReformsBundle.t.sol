// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/IntellectualDiversity.sol";
import "../src/MarketAccountability.sol";
import "../src/FundamentalEducation.sol";
import "../src/ResearchDecentralization.sol";

contract ReformsBundleTest is Test {
    IntellectualDiversity diversity;
    MarketAccountability accountability;
    FundamentalEducation education;
    ResearchDecentralization research;

    function setUp() public {
        diversity = new IntellectualDiversity();
        accountability = new MarketAccountability();
        education = new FundamentalEducation();
        research = new ResearchDecentralization();
    }

    function test_IntellectualDiversity() public {
        diversity.registerViewpoint("Conservative perspective");
        assertEq(diversity.viewpoints(address(this)), "Conservative perspective");
    }

    function test_MarketAccountability() public {
        accountability.setPerformanceScore(address(this), 80);
        accountability.allocateFunding(address(this), 1000);
        assertEq(accountability.performanceScores(address(this)), 80);
    }

    function test_FundamentalEducation() public {
        education.reviewCourse("Logic 101", true);
        assertTrue(education.courseStatus("Logic 101"));
    }

    function test_ResearchDecentralization() public {
        research.createPartnership(address(this), "STEM Research");
        (string memory field, bool active) = research.partners(address(this));
        assertEq(field, "STEM Research");
        assertTrue(active);
    }
}

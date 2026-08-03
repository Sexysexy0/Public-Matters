// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/SovereignTreasuryProtocol.sol";

contract SovereignTreasuryProtocolTest is Test {
    SovereignTreasuryProtocol public treasury;
    address public osg = address(this); // Tayo ang Root Admin / OSG
    address public contractor = address(0x123);

    function setUp() public {
        treasury = new SovereignTreasuryProtocol();
    }

    function testCreateAndFlagProject() public {
        // Bigyan ng pondo ang contract natin
        vm.deal(osg, 100 ether);
        
        // Step 1: Gumawa ng Project (10 ether budget, 4 milestones)
        treasury.createProject{value: 10 ether}("Ghost Bridge ng Malolos", 4);
        
        // Step 2: I-award sa contractor
        treasury.awardProject(0, contractor);
        
        // Step 3: May nag-report! I-execute ang OSG Guillotine
        treasury.flagCorruptProject(0, "Substandard materials detected. Project frozen.");
        
        // Step 4: I-verify kung pumasok ang FLAGGED status
        (,,,,, SovereignTreasuryProtocol.ProjectStatus status) = treasury.publicWorks(0);
        assertEq(uint(status), uint(SovereignTreasuryProtocol.ProjectStatus.FLAGGED));
    }
}

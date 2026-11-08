// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../src/OperatorPrivileges.sol";
import "../src/RoyalCourtRegistry.sol";
import "../src/MarriageRegistry.sol";
import "../src/GameplayQAOracle.sol";

contract GameplayMechanicsTest is Test {
    OperatorPrivileges privileges;
    RoyalCourtRegistry court;
    MarriageRegistry marriage;
    GameplayQAOracle qa;

    address op = vm.addr(1);
    address kliff = vm.addr(2);
    address damiane = vm.addr(3);
    address noble = vm.addr(4);
    address player = vm.addr(5);

    function setUp() public {
        privileges = new OperatorPrivileges();
        privileges.addOperator(op);
        
        court = new RoyalCourtRegistry(address(privileges));
        marriage = new MarriageRegistry(address(privileges));
        qa = new GameplayQAOracle(address(privileges));
    }

    function testDispatchMissionFromThrone() public {
        bytes32 petitionId = court.filePetition(keccak256("noble"), keccak256("Clear bandits"));
        
        vm.prank(op);
        court.dispatchMission(petitionId, keccak256("damiane"));

        RoyalCourtRegistry.Petition memory p = court.getPetition(petitionId);
        assertEq(uint(p.status), uint(RoyalCourtRegistry.MissionStatus.DISPATCHED));
    }

    function testMarryDamianeAndCrownQueen() public {
        bytes32 marriageId = marriage.proposeMarriage(keccak256("kliff"), keccak256("damiane"), bytes32(0));
        
        vm.prank(op);
        marriage.acceptMarriage(marriageId);
        
        vm.prank(op);
        marriage.crownAsQueen(marriageId);

        MarriageRegistry.Marriage memory m = marriage.getMarriage(marriageId);
        assertTrue(m.isQueen);
        assertEq(uint(m.status), uint(MarriageRegistry.MarriageStatus.MARRIED));
    }

    function testPlayerReportsBoatBug() public {
        bytes32 bugId = qa.reportBug(keccak256("player"), keccak256("Boat flips mid-battle"));
        
        GameplayQAOracle.BugReport memory b = qa.getBug(bugId);
        assertEq(uint(b.status), uint(GameplayQAOracle.BugStatus.OPEN));
        
        vm.prank(op);
        qa.updateBugStatus(bugId, GameplayQAOracle.BugStatus.PATCHING);
        
        b = qa.getBug(bugId);
        assertEq(uint(b.status), uint(GameplayQAOracle.BugStatus.PATCHING));
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/AutonomousComplianceEscrowRouter.sol";
import "../contracts/DirectorGovernance.sol";
import "../contracts/HRDDGovernance.sol";
import "../contracts/PublicBenefitGrant.sol";

contract DraftModulesTest is Test {
    AutonomousComplianceEscrowRouter public router;
    DirectorGovernance public directorGov;
    HRDDGovernance public hrddGov;
    PublicBenefitGrant public grant;

    address public admin = address(this);
    address public mockOracle = address(0x1111);
    address public mockEscrow = address(0x2222);

    function setUp() public {
        router = new AutonomousComplianceEscrowRouter(admin, mockOracle, mockEscrow);
        directorGov = new DirectorGovernance(admin);
        hrddGov = new HRDDGovernance(admin);
        grant = new PublicBenefitGrant();
    }

    function test_DirectorGovernance_Deployment() public view {
        assertTrue(address(directorGov) != address(0));
    }

    function test_HRDDGovernance_Deployment() public view {
        assertTrue(address(hrddGov) != address(0));
    }

    function test_AutonomousRouter_Deployment() public view {
        assertTrue(address(router) != address(0));
    }

    function test_PublicBenefitGrant_Deployment() public view {
        assertTrue(address(grant) != address(0));
    }
}

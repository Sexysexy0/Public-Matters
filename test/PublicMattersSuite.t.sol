// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/AccessControlCodex.sol";
import "../contracts/DueProcessCodex.sol";
import "../contracts/DamayStateMachine.sol";
import "../contracts/EmotionalAPR.sol";
import "../contracts/SammaCodex.sol";
import "../contracts/CivicDAO.sol";
import "../contracts/ValidatorRegistry.sol";
import "../contracts/SubsistenceCodex.sol";
import "../contracts/IntegrationRouter.sol";

contract PublicMattersSuite is Test {
    AccessControlCodex access;
    DueProcessCodex dueProcess;
    DamayStateMachine damay;
    EmotionalAPR apr;
    SammaCodex samma;
    CivicDAO civic;
    ValidatorRegistry registry;
    SubsistenceCodex subsistence;
    IntegrationRouter router;

    address adminAddress;

    function setUp() public {
        adminAddress = address(this);
        access = new AccessControlCodex(adminAddress);
        dueProcess = new DueProcessCodex();
        damay = new DamayStateMachine();
        apr = new EmotionalAPR(address(damay));
        samma = new SammaCodex(address(this));
        civic = new CivicDAO(address(samma));
        registry = new ValidatorRegistry();
        subsistence = new SubsistenceCodex();

        router = new IntegrationRouter(
            address(access),
            address(dueProcess),
            address(damay),
            address(apr),
            address(samma),
            address(civic),
            address(registry)
        );
    }

    function testSubsistenceGuarantee() public {
        subsistence.declareGuarantee("Food", "Right to dignified nutrition");
        assertTrue(subsistence.isActive(1));
    }

    function testValidatorLifecycle() public {
        registry.registerValidator(200);
        assertEq(registry.getStake(address(this)), 200);

        registry.slashValidator(address(this), 50, "Violation of principle");
        assertEq(registry.getStake(address(this)), 150);

        registry.updateReputation(address(this), 10, true);
        assertEq(registry.getReputation(address(this)), 110);
    }

    function testGovernanceFlow() public {
        samma.declarePrinciple("No Extortion", "Transparent accusations only");
        assertTrue(samma.isActive(1));

        civic.createProposal("Ban phantom accusations", 1);
        civic.vote(1, true);

        // simulate second voter to avoid "Already voted" error
        vm.prank(address(0xBEEF));
        civic.vote(1, true);

        civic.executeProposal(1);
    }

    function testRouterLinks() public view {
        assertEq(address(router.access()), address(access));
        assertEq(address(router.dueProcess()), address(dueProcess));
        assertEq(address(router.damay()), address(damay));
        assertEq(address(router.apr()), address(apr));
        assertEq(address(router.samma()), address(samma));
        assertEq(address(router.civic()), address(civic));
        assertEq(address(router.registry()), address(registry));
    }

    function testAPRAndDamayIntegration() public {
        bool stateOk = router.updateAPRAndCheckDamay(-100, 0, 0, 0, address(this));
        assertTrue(stateOk);
    }
}

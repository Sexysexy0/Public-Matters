// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/IntegrationRouter.sol";
import "../contracts/AccessControlCodex.sol";
import "../contracts/DueProcessCodex.sol";
import "../contracts/DamayStateMachine.sol";
import "../contracts/EmotionalAPR.sol";
import "../contracts/SammaCodex.sol";
import "../contracts/CivicDAO.sol";
import "../contracts/ValidatorRegistry.sol";

contract IntegrationTests is Test {
    IntegrationRouter router;
    AccessControlCodex access;
    DueProcessCodex dueProcess;
    DamayStateMachine damay;
    EmotionalAPR apr;
    SammaCodex samma;
    CivicDAO civic;
    ValidatorRegistry registry;

    function setUp() public {
        access = new AccessControlCodex(address(this));
        dueProcess = new DueProcessCodex();
        damay = new DamayStateMachine();
        apr = new EmotionalAPR(address(damay));
        samma = new SammaCodex(address(this));
        civic = new CivicDAO(address(samma));
        registry = new ValidatorRegistry();

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

    function testRouterLinks() public view {
        assertEq(address(router.access()), address(access));
        assertEq(address(router.dueProcess()), address(dueProcess));
        assertEq(address(router.damay()), address(damay));
        assertEq(address(router.apr()), address(apr));
        assertEq(address(router.samma()), address(samma));
        assertEq(address(router.civic()), address(civic));
        assertEq(address(router.registry()), address(registry));
    }

    function testAPRTriggersDamayViaRouter() public {
        bool stateOk = router.updateAPRAndCheckDamay(-100, 0, 0, 0, address(this));
        assertTrue(stateOk);
        (DamayStateMachine.DamayPhase phase,) = damay.exchanges(address(this));
        assertEq(uint256(phase), uint256(DamayStateMachine.DamayPhase.Alert));
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import { } from "../contracts/ShariahComplianceRouter.sol";
import { } from "../contracts/InstitutionalAuditHistory.sol";

contract ShariahComplianceRouterTest is Test {
    ShariahComplianceRouter public router;
    InstitutionalAuditHistory public auditHistory;

    address public guardianWallet = address(0x1111);
    address public partnerConduit = address(0x5555);
    address public merchantNode = address(0x6666);
    bytes32 public dummyAgreement = keccak256(abi.encodePacked("MUSHARKAH_ETHICAL_TERMS"));

    function setUp() public {
        vm.startPrank(guardianWallet);
        auditHistory = new InstitutionalAuditHistory();
        router = new ShariahComplianceRouter();

        router.setAuditHistoryAddress(address(auditHistory));
        auditHistory.setLoggerAuthorization(address(router), true);
        vm.stopPrank();

        vm.deal(partnerConduit, 50 ether);
    }

    function test_RegisterEthicalPartnershipFlow() public {
        vm.prank(partnerConduit);
        // Nagpapadala ng 10 ether capital contribution na walang interes (Anti-Riba invariant check)
        uint256 txId = router.registerEthicalTransaction{value: 10 ether}(merchantNode, 20, dummyAgreement);
        assertEq(txId, 1);

        (,,, uint256 amount, uint256 ratio, ShariahComplianceRouter.EthicalStatus status,) = router.transactions(1);
        assertEq(amount, 10 ether);
        assertEq(ratio, 20);
        assertTrue(status == ShariahComplianceRouter.EthicalStatus.Pending);
    }

    function test_FlagNonCompliantBreachTelemetry() public {
        vm.prank(partnerConduit);
        uint256 txId = router.registerEthicalTransaction{value: 10 ether}(merchantNode, 20, dummyAgreement);

        vm.prank(guardianWallet);
        // OPTIMIZED: Ginawang eksaktong 32 characters para magkasya sa bytes32 slot
        router.flagNonCompliantTransaction(txId, "RIBA_DETECT_INTEREST_TRIGGERED");

        (,,,,, ShariahComplianceRouter.EthicalStatus status,) = router.transactions(txId);
        assertTrue(status == ShariahComplianceRouter.EthicalStatus.Flagged);

        // Sinusuri kung pumasok ang +1 warning trigger sa cross-contract master registry log
        (,, uint256 warnings,,,) = auditHistory.viewHistory(partnerConduit);
        assertEq(warnings, 1);
    }
}

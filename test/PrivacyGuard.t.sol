// SPDX-License-Identifier: MIT
pragma solidity ^0.8.35;

import "forge-std/Test.sol";
import "../contracts/PrivacyGuard.sol";

contract PrivacyGuardTest is Test {
    PrivacyGuard public guard;
    address public operator;
    address public automationScript;
    address public unauthorizedUser;

    function setUp() public {
        operator = address(this);
        automationScript = address(0x123);
        unauthorizedUser = address(0x456);
        
        guard = new PrivacyGuard(operator);
    }

    function test_OperatorCanSetAuthorization() public {
        guard.setAuthorization(automationScript, true);
        assertTrue(guard.authorizedAutomations(automationScript));
    }

    function test_RevertWhen_UnauthorizedSetsAuthorization() public {
        vm.prank(unauthorizedUser);
        vm.expectRevert("PrivacyGuard: Caller is not an operator");
        guard.setAuthorization(automationScript, true);
    }

    function test_AuthorizedExecution() public {
        guard.setAuthorization(automationScript, true);
        
        vm.prank(automationScript);
        guard.verifyAndExecute("PDF_GENERATION");
    }

    function test_RevertWhen_UnauthorizedExecution() public {
        vm.prank(unauthorizedUser);
        vm.expectRevert("PrivacyGuard: Access denied");
        guard.verifyAndExecute("UNAUTHORIZED_ACCESS");
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {RoleAuthorityRegistry} from "../contracts/RoleAuthorityRegistry.sol";

/**
 * @dev Simulated downstream execution system module to explicitly test external modifiers checks.
 */
contract MockTarget {
    RoleAuthorityRegistry public registry;
    bytes32 public requiredRole;

    constructor(address _registry, bytes32 _role) {
        registry = RoleAuthorityRegistry(_registry);
        requiredRole = _role;
    }

    // Protected external gateway logic node checkpoint entrypoint
    function executeSecureAction() external view {
        if (!registry.hasRole(requiredRole, msg.sender)) {
            revert RoleAuthorityRegistry.UnauthorizedAccess(msg.sender, requiredRole);
        }
    }
}

contract RoleAuthorityRegistryTest is Test {
    RoleAuthorityRegistry public registry;
    MockTarget public target;
    
    // System identity parameters setup
    address public admin = address(0xAD);
    address public overseer = address(0x01);
    address public steward = address(0x02);
    address public sentinel = address(0x03);
    address public unauthorizedUser = address(0x99);

    function setUp() public {
        // Inisyal na pagluwal sa permission register ledger node
        registry = new RoleAuthorityRegistry(admin);
        
        // I-set up ang custom mock protected system node gateway matrix
        target = new MockTarget(address(registry), registry.OVERSEER_ROLE());
        
        // Pormal na pag-grant ng authorizations sa internal role registry
        vm.startPrank(admin);
        registry.grantRole(registry.OVERSEER_ROLE(), overseer);
        registry.grantRole(registry.STEWARD_ROLE(), steward);
        registry.grantRole(registry.SENTINEL_ROLE(), sentinel);
        vm.stopPrank();
    }

    /**
     * @dev Tinitiyak na ang mga AUTHORIZED system actors ay makakalusot sa security matrix maps.
     */
    function test_Success_AuthorizedAccessMatrix() public view {
        assertTrue(registry.hasRole(registry.OVERSEER_ROLE(), overseer));
        assertTrue(registry.hasRole(registry.STEWARD_ROLE(), steward));
        assertTrue(registry.hasRole(registry.SENTINEL_ROLE(), sentinel));
    }

    /**
     * @dev Forensic Boundary Check: Tinitiyak na ang rogue o unauthorized wallet logs
     * ay awtomatikong sasabog (revert) kapag humipo sa target functional modules.
     */
    function test_Revert_UnauthorizedBypassAttempt() public {
        bytes32 requiredRole = registry.OVERSEER_ROLE();
        
        // I-simulate ang pumasok na cross-contract message node gamit ang rogue profile context
        vm.prank(unauthorizedUser);
        
        // Inaasahan natin na ang mismong panlabas na static call ay bumaril ng complete selector verification error
        vm.expectRevert(
            abi.encodeWithSelector(
                RoleAuthorityRegistry.UnauthorizedAccess.selector, 
                unauthorizedUser, 
                requiredRole
            )
        );
        
        // Hakbang 3: I-execute ang pormal na external instruction loop check transaction call
        target.executeSecureAction();
    }
}

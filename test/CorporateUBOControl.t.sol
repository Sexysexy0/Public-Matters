// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "forge-std/Test.sol";
import "../contracts/CorporateUBOControl.sol";

contract CorporateUBOControlTest is Test {
    CorporateUBOControl uboControl;
    address controller = address(this);
    address unauthorized = address(0x456);

    function setUp() public {
        uboControl = new CorporateUBOControl();
    }

    function testRecordAndVerifyUBO() public {
        bytes32 entityId = keccak256("COMPANY_ALPHA");
        address beneficiary = address(0x789);
        uint256 percentage = 10000; // 100%
        string memory entityName = "Alpha Corp Phil";

        uboControl.recordUBO(entityId, beneficiary, percentage, entityName);

        (address retrievedBeneficiary, uint256 retrievedPct, bool verified, string memory name) = uboControl.getUBO(entityId);
        assertEq(retrievedBeneficiary, beneficiary);
        assertEq(retrievedPct, percentage);
        assertFalse(verified);
        assertEq(name, entityName);

        uboControl.verifyUBO(entityId, true);
        (,, bool verifiedAfter,) = uboControl.getUBO(entityId);
        assertTrue(verifiedAfter);
    }

    function test_RevertWhen_UnauthorizedUBO() public {
        bytes32 entityId = keccak256("COMPANY_BETA");
        vm.prank(unauthorized);
        vm.expectRevert("Unauthorized: Only controller");
        uboControl.recordUBO(entityId, address(0x999), 5000, "Beta Corp");
    }
}

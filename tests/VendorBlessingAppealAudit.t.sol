// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../contracts/VendorBlessingAppealProtocol.sol";

contract VendorBlessingAppealAudit is Test {
    VendorBlessingAppealProtocol protocol;

    function setUp() public {
        protocol = new VendorBlessingAppealProtocol();
    }

    function testSubmitAppeal() public {
        protocol.submitAppeal("VendorX", "Blessing revoked unfairly");
        VendorBlessingAppealProtocol.Appeal memory appeal = protocol.getAppeal(0);
        assertEq(appeal.vendor, "VendorX");
        assertEq(appeal.status, VendorBlessingAppealProtocol.AppealStatus.Pending);
    }

    function testResolveAppealApproved() public {
        protocol.submitAppeal("VendorY", "Blessing revoked due to APR misread");
        protocol.resolveAppeal(0, VendorBlessingAppealProtocol.AppealStatus.Approved);
        VendorBlessingAppealProtocol.Appeal memory appeal = protocol.getAppeal(0);
        assertEq(uint(appeal.status), uint(VendorBlessingAppealProtocol.AppealStatus.Approved));
    }

    function testResolveAppealRejected() public {
        protocol.submitAppeal("VendorZ", "Appeal lacks emotional APR evidence");
        protocol.resolveAppeal(0, VendorBlessingAppealProtocol.AppealStatus.Rejected);
        VendorBlessingAppealProtocol.Appeal memory appeal = protocol.getAppeal(0);
        assertEq(uint(appeal.status), uint(VendorBlessingAppealProtocol.AppealStatus.Rejected));
    }

    function testDoubleResolutionFails() public {
        protocol.submitAppeal("VendorA", "Blessing revoked during sync lag");
        protocol.resolveAppeal(0, VendorBlessingAppealProtocol.AppealStatus.Approved);
        vm.expectRevert();
        protocol.resolveAppeal(0, VendorBlessingAppealProtocol.AppealStatus.Rejected);
    }
}

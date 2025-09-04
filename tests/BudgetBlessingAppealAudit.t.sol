// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../contracts/BudgetBlessingAppealProtocol.sol";

contract BudgetBlessingAppealAudit is Test {
    BudgetBlessingAppealProtocol protocol;

    function setUp() public {
        protocol = new BudgetBlessingAppealProtocol();
    }

    function testSubmitAppeal() public {
        protocol.submitAppeal("Health", "Missing pediatric allocation");
        BudgetBlessingAppealProtocol.Appeal memory appeal = protocol.getAppeal(0);
        assertEq(appeal.sector, "Health");
        assertEq(appeal.status, BudgetBlessingAppealProtocol.AppealStatus.Pending);
    }

    function testResolveAppealApproved() public {
        protocol.submitAppeal("Education", "No scroll-certified teachers");
        protocol.resolveAppeal(0, BudgetBlessingAppealProtocol.AppealStatus.Approved);
        BudgetBlessingAppealProtocol.Appeal memory appeal = protocol.getAppeal(0);
        assertEq(uint(appeal.status), uint(BudgetBlessingAppealProtocol.AppealStatus.Approved));
    }

    function testResolveAppealRejected() public {
        protocol.submitAppeal("Infrastructure", "Request for mythic bridges");
        protocol.resolveAppeal(0, BudgetBlessingAppealProtocol.AppealStatus.Rejected);
        BudgetBlessingAppealProtocol.Appeal memory appeal = protocol.getAppeal(0);
        assertEq(uint(appeal.status), uint(BudgetBlessingAppealProtocol.AppealStatus.Rejected));
    }

    function testDoubleResolutionFails() public {
        protocol.submitAppeal("Housing", "Kinder Queen shelter missing");
        protocol.resolveAppeal(0, BudgetBlessingAppealProtocol.AppealStatus.Approved);
        vm.expectRevert();
        protocol.resolveAppeal(0, BudgetBlessingAppealProtocol.AppealStatus.Rejected);
    }
}

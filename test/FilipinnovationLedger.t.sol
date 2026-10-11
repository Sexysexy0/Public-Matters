// SPDX-License-Identifier: MIT
pragma solidity 0.8.35;

import "forge-std/Test.sol";
import "../src/FilipinnovationLedger.sol";

contract FilipinnovationLedgerTest is Test {
    FilipinnovationLedger ledger;

    address admin = address(this);
    address outsider = address(0xBAD);
    address innovatorA = address(0xA1);

    function setUp() public {
        ledger = new FilipinnovationLedger();
    }

    function testRegisterInnovator() public {
        ledger.registerInnovator(innovatorA, "Alice", "agritech", "FarmCo", "desc", "ipfs://a");

        assertEq(ledger.innovatorsLength(), 1);
        assertTrue(ledger.isVerifiedInnovator(innovatorA));

        (
            address wallet,,,,,,,
        ) = ledger.innovators(0);
        assertEq(wallet, innovatorA);
    }

    function testCannotRegisterTwice() public {
        ledger.registerInnovator(innovatorA, "Alice", "agritech", "FarmCo", "d", "ipfs://a");
        vm.expectRevert("Already verified");
        ledger.registerInnovator(innovatorA, "Alice", "agritech", "FarmCo", "d", "ipfs://a");
    }

    function testCannotRegisterZeroWallet() public {
        vm.expectRevert("wallet=0");
        ledger.registerInnovator(address(0), "Alice", "agritech", "FarmCo", "d", "ipfs://a");
    }

    function testAwardGrant() public {
        ledger.registerInnovator(innovatorA, "Alice", "agritech", "FarmCo", "d", "ipfs://a");
        uint256 id = ledger.awardGrant(innovatorA, "Project X", 100 ether, "M1", "ipfs://g");

        assertEq(id, 0);
        assertEq(ledger.grantsLength(), 1);

        FilipinnovationLedger.Grant memory g = _getGrant(0);
        assertEq(g.id, 0);
        assertEq(g.innovator, innovatorA);
        assertEq(g.projectName, "Project X");
    }

    function testCannotAwardToUnverified() public {
        vm.expectRevert("Not verified");
        ledger.awardGrant(innovatorA, "Project X", 100 ether, "M1", "ipfs://g");
    }

    function testCannotAwardZero() public {
        ledger.registerInnovator(innovatorA, "Alice", "agritech", "FarmCo", "d", "ipfs://a");
        vm.expectRevert("amount=0");
        ledger.awardGrant(innovatorA, "Project X", 0, "M1", "ipfs://g");
    }

    function testDisburseGrant() public {
        ledger.registerInnovator(innovatorA, "Alice", "agritech", "FarmCo", "d", "ipfs://a");
        uint256 gid = ledger.awardGrant(innovatorA, "Project X", 100 ether, "M1", "ipfs://g");

        ledger.disburseGrant(gid, 40 ether);

        // Grant struct: id, innovator, projectName, amount, awardedDate,
        //               disbursedAmount, fullyDisbursed, milestone, timestamp, ipfsHash
        FilipinnovationLedger.Grant memory g = _getGrant(gid);
        assertEq(g.disbursedAmount, 40 ether);
        assertFalse(g.fullyDisbursed);

        ledger.disburseGrant(gid, 60 ether);
        g = _getGrant(gid);
        assertEq(g.disbursedAmount, 100 ether);
        assertTrue(g.fullyDisbursed);
    }

    function testCannotOverDisburse() public {
        ledger.registerInnovator(innovatorA, "Alice", "agritech", "FarmCo", "d", "ipfs://a");
        uint256 gid = ledger.awardGrant(innovatorA, "Project X", 100 ether, "M1", "ipfs://g");

        vm.expectRevert("Exceeds grant amount");
        ledger.disburseGrant(gid, 101 ether);
    }

    function testCannotDisburseAfterFully() public {
        ledger.registerInnovator(innovatorA, "Alice", "agritech", "FarmCo", "d", "ipfs://a");
        uint256 gid = ledger.awardGrant(innovatorA, "Project X", 100 ether, "M1", "ipfs://g");
        ledger.disburseGrant(gid, 100 ether);

        vm.expectRevert("Already fully disbursed");
        ledger.disburseGrant(gid, 1 ether);
    }

    function testLogCommercialization() public {
        ledger.registerInnovator(innovatorA, "Alice", "agritech", "FarmCo", "d", "ipfs://a");
        uint256 gid = ledger.awardGrant(innovatorA, "Project X", 100 ether, "M1", "ipfs://g");
        uint256 cid = ledger.logCommercialization(gid, "Widget", "PH", 50 ether, "notes", "ipfs://c");

        assertEq(cid, 0);
        assertEq(ledger.commercializationsLength(), 1);
    }

    function testCannotCommercializeMissingGrant() public {
        vm.expectRevert("Grant not found");
        ledger.logCommercialization(999, "Widget", "PH", 50 ether, "notes", "ipfs://c");
    }

    function testLogImpactEvent() public {
        uint256 eid = ledger.logImpactEvent("environmental", "reduced CO2", 85, "ipfs://i");

        assertEq(eid, 0);
        assertEq(ledger.impactEventsLength(), 1);
    }

    function testOnlyAdminCanRegister() public {
        vm.prank(outsider);
        vm.expectRevert("Not admin");
        ledger.registerInnovator(innovatorA, "Alice", "agritech", "FarmCo", "d", "ipfs://a");
    }

    function testOnlyAdminCanLogImpact() public {
        vm.prank(outsider);
        vm.expectRevert("Not admin");
        ledger.logImpactEvent("x", "y", 1, "ipfs://i");
    }

    // Helper: read the full Grant struct via the auto-generated getter.
    // The `public grants` getter returns each field positionally; using it
    // directly requires listing every field. This wrapper keeps call sites
    // readable.
    function _getGrant(uint256 gid) internal view returns (FilipinnovationLedger.Grant memory) {
        (
            uint256 id,
            address innovator,
            string memory projectName,
            uint256 amount,
            uint256 awardedDate,
            uint256 disbursedAmount,
            bool fullyDisbursed,
            string memory milestone,
            uint256 timestamp,
            string memory ipfsHash
        ) = ledger.grants(gid);

        return FilipinnovationLedger.Grant({
            id:              id,
            innovator:       innovator,
            projectName:     projectName,
            amount:          amount,
            awardedDate:     awardedDate,
            disbursedAmount: disbursedAmount,
            fullyDisbursed:  fullyDisbursed,
            milestone:       milestone,
            timestamp:       timestamp,
            ipfsHash:        ipfsHash
        });
    }
}

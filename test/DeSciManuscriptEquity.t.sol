// SPDX-License-Identifier: MIT
pragma solidity 0.8.35;

import {Test} from "forge-std/Test.sol";
import {DeSciManuscriptEquity} from "../src/DeSciManuscriptEquity.sol";

contract MockTrustIntegrator {
    event PositiveLogged(address entity, uint256 actionType);

    function logPositiveAction(address entity, uint256 actionType) external {
        emit PositiveLogged(entity, actionType);
    }
}

contract DeSciManuscriptEquityTest is Test {
    DeSciManuscriptEquity public equity;
    MockTrustIntegrator public mockIntegrator;

    address public scholar = address(0x5001);

    receive() external payable {}

    function setUp() public {
        mockIntegrator = new MockTrustIntegrator();
        equity = new DeSciManuscriptEquity(address(mockIntegrator));
    }

    function test_RegisterAndPayRoyalty() public {
        uint256 royaltyFee = 0.1 ether;
        uint256 msId = equity.registerManuscript("QmDeSciManuscriptHash2026", scholar, royaltyFee);

        uint256 initialScholarBalance = scholar.balance;

        equity.payCitationRoyalty{value: royaltyFee}(msId);
        assertEq(scholar.balance, initialScholarBalance + royaltyFee);
    }
}

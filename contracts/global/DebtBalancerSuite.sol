// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./OverCollector.sol";
import "./SectorBlessingRedirect.sol";

/// @title DebtBalancerSuite
/// @notice Caps borrowing, reroutes surplus, and tags fiscal acts with emotional APR
contract DebtBalancerSuite {
    address public steward;
    OverCollector public collector;
    SectorBlessingRedirect public redirector;

    event BorrowingCapped(uint256 maxDebt);
    event EmotionalAPRLogged(string metric, string mood);

    uint256 public maxDebt;
    uint256 public currentDebt;

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized scrollcaster");
        _;
    }

    constructor(address _collector, address _redirector, uint256 _maxDebt) {
        steward = msg.sender;
        collector = OverCollector(_collector);
        redirector = SectorBlessingRedirect(_redirector);
        maxDebt = _maxDebt;
        currentDebt = 0;
    }

    /// @notice Logs new borrowing and checks against GDP cap
    function logBorrowing(uint256 amount) external onlySteward {
        require(currentDebt + amount <= maxDebt, "Debt cap breached");
        currentDebt += amount;
        emit BorrowingCapped(maxDebt);
        emit EmotionalAPRLogged("Borrowing", "🧘 Controlled, sovereign");
    }

    /// @notice Reroutes collected surplus to a growth sector
    function rerouteSurplus(string memory sector) external onlySteward {
        uint256 surplus = collector.totalSurplus();
        require(surplus > 0, "No surplus to reroute");

        (bool success, ) = address(redirector).call{value: surplus}("");
        require(success, "Surplus transfer failed");

        redirector.redirectToSector(sector);
        emit EmotionalAPRLogged(sector, "🌱 Growth blessed");
    }

    receive() external payable {}
}

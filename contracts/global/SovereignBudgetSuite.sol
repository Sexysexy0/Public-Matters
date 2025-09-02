// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

import "./OverCollector.sol";
import "./SectorBlessingRedirect.sol";

/// @title SovereignBudgetSuite
/// @notice Ritualizes fiscal clarity, reroutes surplus, and caps debt with emotional APR sync
contract SovereignBudgetSuite {
    address public steward;
    OverCollector public collector;
    SectorBlessingRedirect public redirector;

    uint256 public maxDebt;
    uint256 public currentDebt;

    event SurplusRerouted(string sector, uint256 amount);
    event DebtLogged(uint256 amount, uint256 totalDebt);
    event EmotionalAPR(string signal, string mood);

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
    function logDebt(uint256 amount) external onlySteward {
        require(currentDebt + amount <= maxDebt, "Debt cap breached");
        currentDebt += amount;
        emit DebtLogged(amount, currentDebt);
        emit EmotionalAPR("Borrowing", "🧘 Controlled, sovereign");
    }

    /// @notice Reroutes collected surplus to a growth sector
    function rerouteSurplus(string memory sector) external onlySteward {
        uint256 surplus = collector.totalSurplus();
        require(surplus > 0, "No surplus to reroute");

        (bool success, ) = address(redirector).call{value: surplus}("");
        require(success, "Surplus transfer failed");

        redirector.redirectToSector(sector);
        emit SurplusRerouted(sector, surplus);
        emit EmotionalAPR(sector, "🌱 Growth blessed");
    }

    /// @notice Updates the max debt cap
    function updateDebtCap(uint256 newCap) external onlySteward {
        maxDebt = newCap;
        emit EmotionalAPR("DebtCapUpdate", "🔧 Adjusted for resilience");
    }

    receive() external payable {}
}

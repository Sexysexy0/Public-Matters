// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract BudgetIntegrityArc {
    event BudgetReported(string project, uint256 reported, uint256 timestamp);
    event BudgetActual(string project, uint256 actual, uint256 timestamp);
    event DiscrepancyFlag(string project, uint256 reported, uint256 actual, bool discrepancy);
    event EquitySafeguard(string context, string safeguard);
    event OversightResonance(address indexed reviewer, string action, string safeguard);
    event DignityContinuity(string context, string safeguard);

    address public overseer;

    constructor(address _overseer) {
        overseer = _overseer;
    }

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    function reportBudget(string memory project, uint256 reported) external onlyOverseer {
        emit BudgetReported(project, reported, block.timestamp);
    }

    function logActual(string memory project, uint256 actual) external onlyOverseer {
        emit BudgetActual(project, actual, block.timestamp);
    }

    function checkDiscrepancy(string memory project, uint256 reported, uint256 actual) external onlyOverseer {
        bool discrepancy = actual > reported;
        emit DiscrepancyFlag(project, reported, actual, discrepancy);
    }

    function safeguardEquity(string memory context, string memory safeguard) external onlyOverseer {
        emit EquitySafeguard(context, safeguard);
    }

    function logOversight(string memory action, string memory safeguard) external {
        emit OversightResonance(msg.sender, action, safeguard);
    }

    function safeguardDignityContinuity(string memory context, string memory safeguard) external onlyOverseer {
        emit DignityContinuity(context, safeguard);
    }
}

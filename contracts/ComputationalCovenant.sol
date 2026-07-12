// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Computational Covenant
/// @notice Systemic fairness contract inspired by bounded computation
contract ComputationalCovenant {
    address public guardian;
    uint256 public anomalyAllowance; // % anomaly allowed (illusion of choice)
    uint256 public cycleCount;       // bilang ng reset cycles
    mapping(uint256 => address) public chosenOnes; // record ng bawat "One"

    event GuardianChanged(address indexed oldGuardian, address indexed newGuardian);
    event CycleReset(uint256 indexed cycleId, address indexed chosenOne);
    event AnomalyAllowanceChanged(uint256 oldAllowance, uint256 newAllowance);

    constructor(uint256 _anomalyAllowance) {
        guardian = msg.sender;
        anomalyAllowance = _anomalyAllowance; // default 1% anomaly
        cycleCount = 0;
    }

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Not authorized");
        _;
    }

    /// @notice Palitan ang guardian
    function changeGuardian(address newGuardian) external onlyGuardian {
        require(newGuardian != address(0), "Invalid guardian");
        emit GuardianChanged(guardian, newGuardian);
        guardian = newGuardian;
    }

    /// @notice Baguhin ang anomaly allowance (% ng dissent na pinapayagan)
    function setAnomalyAllowance(uint256 newAllowance) external onlyGuardian {
        emit AnomalyAllowanceChanged(anomalyAllowance, newAllowance);
        anomalyAllowance = newAllowance;
    }

    /// @notice Mag‑reset ng cycle at mag‑record ng bagong "Chosen One"
    function resetCycle(address chosenOne) external onlyGuardian {
        cycleCount++;
        chosenOnes[cycleCount] = chosenOne;
        emit CycleReset(cycleCount, chosenOne);
    }

    /// @notice Tingnan ang kasalukuyang anomaly allowance
    function viewAnomalyAllowance() external view returns (uint256) {
        return anomalyAllowance;
    }

    /// @notice Tingnan ang huling "Chosen One"
    function latestChosenOne() external view returns (address) {
        return chosenOnes[cycleCount];
    }
}

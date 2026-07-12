// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Covenant Finality
/// @notice Closure and ultimate decision contract for covenant governance
contract CovenantFinality {
    address public guardian;
    uint256 public decisionCount;

    struct Decision {
        uint256 id;
        string subject;
        string resolution;
        bool final;
    }

    mapping(uint256 => Decision) public decisions;

    event GuardianChanged(address indexed oldGuardian, address indexed newGuardian);
    event DecisionRecorded(uint256 indexed id, string subject);
    event DecisionFinalized(uint256 indexed id, string resolution);

    constructor() {
        guardian = msg.sender;
        decisionCount = 0;
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

    /// @notice Mag‑record ng decision draft
    function recordDecision(string calldata subject) external onlyGuardian {
        decisionCount++;
        decisions[decisionCount] = Decision(decisionCount, subject, "", false);
        emit DecisionRecorded(decisionCount, subject);
    }

    /// @notice Mag‑finalize ng decision at mag‑assign ng resolution
    function finalizeDecision(uint256 id, string calldata resolution) external onlyGuardian {
        Decision storage d = decisions[id];
        require(!d.final, "Already finalized");
        d.resolution = resolution;
        d.final = true;
        emit DecisionFinalized(id, resolution);
    }

    /// @notice Tingnan ang decision details
    function viewDecision(uint256 id) external view returns (Decision memory) {
        return decisions[id];
    }
}

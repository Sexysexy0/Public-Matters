// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title AffirmativeActionSentinel
/// @notice Sentinel safeguard to monitor policy mismatches and unintended harms
contract AffirmativeActionSentinel {
    address public overseer;
    uint256 public sentinelCount;

    struct PolicyCheck {
        uint256 id;
        string policy;       // e.g. affirmative action, admissions, institutional rule
        string status;       // aligned, mismatch, loophole
        string safeguard;    // fairness, preparedness, integrity
        string notes;        // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => PolicyCheck) public checks;

    event PolicyFlagged(uint256 indexed id, string policy, string status, string safeguard, string notes);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer flags policy mismatch
    function flagPolicy(string calldata policy, string calldata status, string calldata safeguard, string calldata notes) external onlyOverseer {
        sentinelCount++;
        checks[sentinelCount] = PolicyCheck({
            id: sentinelCount,
            policy: policy,
            status: status,
            safeguard: safeguard,
            notes: notes,
            timestamp: block.timestamp
        });
        emit PolicyFlagged(sentinelCount, policy, status, safeguard, notes);
    }

    /// @notice Citizens can view policy checks
    function viewPolicy(uint256 id) external view returns (PolicyCheck memory) {
        return checks[id];
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title PolicyMismatchSentinel
/// @notice Sentinel safeguard to monitor unintended harms of institutional policies
contract PolicyMismatchSentinel {
    address public overseer;
    uint256 public sentinelCount;

    struct PolicyMismatch {
        uint256 id;
        string policy;       // e.g. affirmative action, education reform
        string status;       // aligned, mismatch, harmful
        string safeguard;    // fairness, preparedness, accountability
        string notes;        // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => PolicyMismatch) public mismatches;

    event MismatchFlagged(uint256 indexed id, string policy, string status, string safeguard, string notes);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer flags policy mismatch
    function flagMismatch(string calldata policy, string calldata status, string calldata safeguard, string calldata notes) external onlyOverseer {
        sentinelCount++;
        mismatches[sentinelCount] = PolicyMismatch({
            id: sentinelCount,
            policy: policy,
            status: status,
            safeguard: safeguard,
            notes: notes,
            timestamp: block.timestamp
        });
        emit MismatchFlagged(sentinelCount, policy, status, safeguard, notes);
    }

    /// @notice Citizens can view flagged mismatches
    function viewMismatch(uint256 id) external view returns (PolicyMismatch memory) {
        return mismatches[id];
    }
}

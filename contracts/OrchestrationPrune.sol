// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title OrchestrationPrune
/// @notice Covenant to prune unwanted AI orchestration flows
contract OrchestrationPrune {
    address public oversightCommittee;
    uint256 public pruneCount;

    struct PruneRecord {
        uint256 id;
        string category;   // e.g. storytelling, war, manipulation
        string action;     // removed, restricted, corrected
        string notes;
        uint256 timestamp;
    }

    mapping(uint256 => PruneRecord) public prunes;

    event FlowPruned(uint256 indexed id, string category, string action, string notes);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Oversight prunes unwanted orchestration flows
    function pruneFlow(string calldata category, string calldata action, string calldata notes) external onlyOversight {
        pruneCount++;
        prunes[pruneCount] = PruneRecord({
            id: pruneCount,
            category: category,
            action: action,
            notes: notes,
            timestamp: block.timestamp
        });
        emit FlowPruned(pruneCount, category, action, notes);
    }

    /// @notice Citizens can view prune records
    function viewPrune(uint256 id) external view returns (PruneRecord memory) {
        return prunes[id];
    }
}

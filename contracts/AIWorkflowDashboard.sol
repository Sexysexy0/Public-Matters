// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title AI Workflow Dashboard
/// @notice Provides citizen-facing transparency for AI workflow actions and governance.
/// @dev Complements AIWorkflowEnhancement, AIWorkflowLedger, and AIWorkflowCouncil by making workflow visible to the public.

contract AIWorkflowDashboard {
    address public guardian;
    uint256 public displayCount;

    enum DisplayType {
        SummaryShown,
        DissectionShown,
        BestSuggestionShown,
        NanoRitualDisplayed,
        MemoryContinuityShown,
        TopicSynchronizationShown,
        GovernanceEffectDisplayed,
        ViolationDisplayed,
        CouncilResolutionDisplayed
    }

    struct DisplayEntry {
        uint256 id;
        DisplayType displayType;
        string content;
        uint256 timestamp;
    }

    mapping(uint256 => DisplayEntry) public displays;

    event DisplayRecorded(uint256 indexed id, DisplayType displayType);

    constructor() {
        guardian = msg.sender;
        displayCount = 0;
    }

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Guardian only");
        _;
    }

    function recordDisplay(DisplayType displayType, string calldata content) external onlyGuardian {
        displayCount++;
        displays[displayCount] = DisplayEntry(
            displayCount,
            displayType,
            content,
            block.timestamp
        );

        emit DisplayRecorded(displayCount, displayType);
    }

    function getDisplay(uint256 id) external view returns (DisplayEntry memory) {
        return displays[id];
    }
}

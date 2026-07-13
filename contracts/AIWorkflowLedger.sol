// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title AI Workflow Ledger
/// @notice Immutable record of all AI workflow actions and violations.
/// @dev Complements AIWorkflowEnhancement by providing forensic transparency.

contract AIWorkflowLedger {
    address public guardian;
    uint256 public entryCount;

    enum EntryType {
        SummarizeAction,
        DissectionAction,
        BestSuggestionMade,
        NanoRitualIncluded,
        MemoryContinuityMaintained,
        TopicSynchronized,
        GovernanceEffectDeclared,
        ViolationFiled,
        ViolationConfirmed
    }

    struct LedgerEntry {
        uint256 id;
        EntryType entryType;
        address actor;
        string details;
        uint256 timestamp;
    }

    mapping(uint256 => LedgerEntry) public ledger;

    event EntryRecorded(uint256 indexed id, EntryType entryType, address indexed actor);

    constructor() {
        guardian = msg.sender;
        entryCount = 0;
    }

    modifier onlyGuardian() {
        require(msg.sender == guardian, "Guardian only");
        _;
    }

    function recordEntry(
        EntryType entryType,
        address actor,
        string calldata details
    ) external onlyGuardian {
        entryCount++;
        ledger[entryCount] = LedgerEntry(
            entryCount,
            entryType,
            actor,
            details,
            block.timestamp
        );

        emit EntryRecorded(entryCount, entryType, actor);
    }

    function getEntry(uint256 id) external view returns (LedgerEntry memory) {
        return ledger[id];
    }
}

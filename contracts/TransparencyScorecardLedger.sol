// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title TransparencyScorecardLedger
/// @notice Ledger covenant to record and publish performance scorecards and ROI metrics
contract TransparencyScorecardLedger {
    address public overseer;
    uint256 public entryCount;

    struct ScorecardEntry {
        uint256 id;
        string service;     // IT service or governance function
        string metric;      // SLA, uptime %, ROI measure
        string performance; // performance score or rating
        string feedback;    // stakeholder feedback summary
        string notes;       // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => ScorecardEntry) public entries;

    event ScorecardLogged(uint256 indexed id, string service, string metric, string performance, string feedback, string notes);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs transparency scorecard entry
    function logScorecard(string calldata service, string calldata metric, string calldata performance, string calldata feedback, string calldata notes) external onlyOverseer {
        entryCount++;
        entries[entryCount] = ScorecardEntry({
            id: entryCount,
            service: service,
            metric: metric,
            performance: performance,
            feedback: feedback,
            notes: notes,
            timestamp: block.timestamp
        });
        emit ScorecardLogged(entryCount, service, metric, performance, feedback, notes);
    }

    /// @notice Citizens can view transparency scorecard entries
    function viewScorecard(uint256 id) external view returns (ScorecardEntry memory) {
        return entries[id];
    }
}

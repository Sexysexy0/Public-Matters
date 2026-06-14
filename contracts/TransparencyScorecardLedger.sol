// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title TransparencyScorecardLedger
/// @notice Ledger covenant to publish performance scorecards and ROI metrics
contract TransparencyScorecardLedger {
    address public overseer;
    uint256 public entryCount;

    struct ScorecardRecord {
        uint256 id;
        string institution;   // company, ORIC, or organization
        string metric;        // KPI (funding success, payroll equity, benefits redistribution)
        uint256 value;        // numeric value of metric
        string outcome;       // qualitative outcome (improved, stable, declined)
        string feedback;      // stakeholder feedback summary
        uint256 timestamp;
    }

    mapping(uint256 => ScorecardRecord) public records;

    event ScorecardLogged(uint256 indexed id, string institution, string metric, uint256 value, string outcome, string feedback);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs transparency scorecard record
    function logScorecard(string calldata institution, string calldata metric, uint256 value, string calldata outcome, string calldata feedback) external onlyOverseer {
        entryCount++;
        records[entryCount] = ScorecardRecord({
            id: entryCount,
            institution: institution,
            metric: metric,
            value: value,
            outcome: outcome,
            feedback: feedback,
            timestamp: block.timestamp
        });
        emit ScorecardLogged(entryCount, institution, metric, value, outcome, feedback);
    }

    /// @notice Citizens can view transparency scorecard records
    function viewScorecard(uint256 id) external view returns (ScorecardRecord memory) {
        return records[id];
    }
}

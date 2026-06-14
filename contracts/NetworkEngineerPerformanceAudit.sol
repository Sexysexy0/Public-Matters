// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IAuditHistory.sol";

/**
 * @title NetworkEngineerPerformanceAudit
 * @dev Hango sa Cajon Valley Union School District A-128 Protocol.
 * Sinusuri ang packet tracing uptime at hardware maintenance diagnostics score ng engineers.
 */
contract NetworkEngineerPerformanceAudit {
    address public sovereignContractor;
    IAuditHistory public auditHistory;

    enum CompetencyRating { Unsatisfactory, NeedsImprovement, MeetsStandards, Outstanding }

    struct AssessmentProfile {
        uint256 id;
        address engineerNode;
        uint256 averageUptimePerformance; // Base 10000 precision (9999 = 99.99%)
        CompetencyRating generalSkillsScore;
        bool hasActiveClearance;
    }

    mapping(address => AssessmentProfile) public evaluationRegistry;
    uint256 public totalAudits;

    event EngineerAudited(address indexed engineer, CompetencyRating rating, uint256 uptime);
    event EngineerSanctioned(address indexed engineer);

    modifier onlyContractor() {
        require(msg.sender == sovereignContractor, "Error: Only Sovereign Contractor access.");
        _;
    }

    constructor() {
        sovereignContractor = msg.sender;
    }

    function setAuditHistoryAddress(address _auditHistoryAddress) public onlyContractor {
        auditHistory = IAuditHistory(_auditHistoryAddress);
    }

    /**
     * @dev CAJON VALLEY A-128 PERFORMANCE LOGIC
     * FIXED: Itinuwid ang enum component name check (`CompetencyRating.MeetsStandards`) upang mawala ang typing stutter distortion.
     */
    function logPersonnelPerformance(
        address _engineer,
        uint256 _uptime,
        CompetencyRating _rating
    ) public onlyContractor returns (uint256) {
        require(_engineer != address(0), "Error: Invalid engineer node address.");
        require(_uptime <= 10000, "Error: Uptime percentage bounds exceeded.");

        totalAudits++;
        bool clearanceResult = (_rating >= CompetencyRating.MeetsStandards && _uptime >= 9500);

        evaluationRegistry[_engineer] = AssessmentProfile({
            id: totalAudits,
            engineerNode: _engineer,
            averageUptimePerformance: _uptime,
            generalSkillsScore: _rating,
            hasActiveClearance: clearanceResult
        });

        emit EngineerAudited(_engineer, _rating, _uptime);

        if (!clearanceResult) {
            emit EngineerSanctioned(_engineer);
            if (address(auditHistory) != address(0)) {
                try auditHistory.logHistoricalAction(_engineer, 0, 0, 1, "ENGINEER_PERF_SANCTION_FLAG") {} catch {}
            }
        } else {
            if (address(auditHistory) != address(0)) {
                try auditHistory.logHistoricalAction(_engineer, 0, 1, 0, "ENGINEER_PERF_COMPLIANT") {} catch {}
            }
        }

        return totalAudits;
    }
}

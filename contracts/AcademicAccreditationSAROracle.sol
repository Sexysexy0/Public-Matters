// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IAuditHistory.sol";

contract AcademicAccreditationSAROracle {
    address public sovereignContractor;
    IAuditHistory public auditHistory;
    
    uint256 public constant MIN_CO_THRESHOLD = 70; // 70% minimum outcome threshold
    uint256 public totalEvaluations;

    struct EvaluationProfile {
        uint256 id;
        string programTierName;
        uint256 courseOutcomeAttainmentScore;
        uint256 programOutcomeAttainmentScore;
        bool isAccredited;
    }

    mapping(uint256 => EvaluationProfile) public reports;

    event EvaluationLogged(uint256 indexed id, string tier, uint256 coScore, bool accredited);

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
     * @dev NBA TIER-I GRADUATE ATTRIBUTES V4.0 VERIFICATION LOOP: Awtomatikong nirereject 
     * at nire-revert ng system ang accreditation registration draw kung ang ipinasang 
     * Course Outcome (CO) metric attainment layer ay bumaba sa strict 70% floor rule.
     */
    function processProgramAccreditationSAR(
        string memory _tierName,
        uint256 _coScore,
        uint256 _poScore,
        bytes32 _evidenceHash
    ) public onlyContractor returns (uint256) {
        require(_coScore <= 100 && _poScore <= 100, "Error: Percentages bounds exceeded.");
        
        // NBA ATTAINMENT COMPLIANCE CHECK
        require(_coScore >= MIN_CO_THRESHOLD, "Error: Accreditation rejected. Course Outcome attainment falls below strict 70% threshold.");

        totalEvaluations++;
        bool statusResult = (_poScore >= 70);

        reports[totalEvaluations] = EvaluationProfile({
            id: totalEvaluations,
            programTierName: _tierName,
            courseOutcomeAttainmentScore: _coScore,
            programOutcomeAttainmentScore: _poScore,
            isAccredited: statusResult
        });

        emit EvaluationLogged(totalEvaluations, _tierName, _coScore, statusResult);

        if (address(auditHistory) != address(0)) {
            try auditHistory.logHistoricalAction(msg.sender, 0, statusResult ? 1 : 0, statusResult ? 0 : 1, _evidenceHash) {} catch {}
        }
        return totalEvaluations;
    }
}

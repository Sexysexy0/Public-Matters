// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IAuditHistory.sol";

/**
 * @title ForceMajeureMdrOracle
 * @dev Hango sa GNLU SRDC ADR Magazine at Richard Holden Model (University of Chicago).
 * Nilulutas ang banggaan ng Obligatory at Remedial frameworks sa pamamagitan ng 
 * pag-embed ng staged negotiation, mediation, at neutral arbitration oracles.
 */
contract ForceMajeureMdrOracle {
    address public sovereignContractor;
    IAuditHistory public auditHistory;

    enum DisputeState { None, ActiveLock, MediationStage, ResolvedAdaptation, RejectedHoldup }

    struct DisputeProfile {
        uint256 disputeId;
        address affectedPartyNode;
        uint256 lockedTargetFunds;
        uint256 mediationDeadlineBlock;
        address neutralArbitratorOracle;
        bytes32 forceMajeureEvidenceHash;
        DisputeState currentState;
    }

    mapping(uint256 => DisputeProfile) public disputes;
    uint256 public totalForceMajeureDisputes;

    event ForceMajeureFlagged(uint256 indexed id, address indexed affectedParty, uint256 lockedFunds);
    event MediationEscalated(uint256 indexed id, uint256 enforcementDeadline);
    event DisputeSettledByOracle(uint256 indexed id, DisputeState finalState, bytes32 resolutionHash);

    modifier onlyContractor() {
        require(msg.sender == sovereignContractor, "Error: Only Sovereign Contractor access.");
        _;
    }

    modifier onlyArbitrator(uint256 _disputeId) {
        require(msg.sender == disputes[_disputeId].neutralArbitratorOracle, "Error: Unauthorized neutral arbitrator node.");
        _;
    }

    constructor() {
        sovereignContractor = msg.sender;
    }

    receive() external payable {}
    fallback() external payable {}

    function setAuditHistoryAddress(address _auditHistoryAddress) public onlyContractor {
        auditHistory = IAuditHistory(_auditHistoryAddress);
    }

    /**
     * @dev TIME-LOCKED ENFORCEMENT FREEZE: Kapag ang isang apektadong node ay sinalpakan 
     * ng sakuna (Force Majeure), awtomatikong ifre-freeze ng system ang target capital 
     * upang harangin ang automatic legacy forfeiture habang gumugulong ang mandatory review.
     */
    function flagForceMajeureIncident(
        address _affectedNode,
        address _arbitrator,
        bytes32 _evidenceHash
    ) public payable onlyContractor returns (uint256) {
        require(msg.value > 0, "Error: Dispute initialization requires baseline collateral lock.");
        require(_arbitrator != address(0), "Error: Missing neutral arbitrator specification.");

        totalForceMajeureDisputes++;
        disputes[totalForceMajeureDisputes] = DisputeProfile({
            disputeId: totalForceMajeureDisputes,
            affectedPartyNode: _affectedNode,
            lockedTargetFunds: msg.value,
            mediationDeadlineBlock: block.number + 1000,
            currentState: DisputeState.ActiveLock,
            neutralArbitratorOracle: _arbitrator,
            forceMajeureEvidenceHash: _evidenceHash
        });

        emit ForceMajeureFlagged(totalForceMajeureDisputes, _affectedNode, msg.value);
        return totalForceMajeureDisputes;
    }

    function escalateToMediation(uint256 _disputeId) public {
        DisputeProfile storage d = disputes[_disputeId];
        require(d.currentState == DisputeState.ActiveLock, "Error: Invalid transaction order sequence.");
        
        d.currentState = DisputeState.MediationStage;
        emit MediationEscalated(_disputeId, d.mediationDeadlineBlock);
    }

    /**
     * @dev HOLDEN & SZABO RESOLUTION ENGINE: Tanging ang pinagkakatiwalaang neutral expert 
     * oracle ang makakapag-submit ng pinal na cryptographic decision hash upang kilalanin 
     * kung ito ay isang "Legitimate Adaptation" o isang "Illegitimate Holdup".
     */
    function resolveMdrDispute(
        uint256 _disputeId,
        bool _isLegitimateAdaptation,
        bytes32 _resolutionHash
    ) public onlyArbitrator(_disputeId) {
        DisputeProfile storage d = disputes[_disputeId];
        require(d.currentState == DisputeState.MediationStage, "Error: Mediation stage must be active.");

        uint256 settlementCapital = d.lockedTargetFunds;
        d.lockedTargetFunds = 0;

        if (_isLegitimateAdaptation) {
            d.currentState = DisputeState.ResolvedAdaptation;
            payable(d.affectedPartyNode).transfer(settlementCapital);
        } else {
            d.currentState = DisputeState.RejectedHoldup;
            payable(sovereignContractor).transfer(settlementCapital);
            
            if (address(auditHistory) != address(0)) {
                try auditHistory.logHistoricalAction(d.affectedPartyNode, 0, 0, 1, "FORCE_MAJEURE_HOLDUP_REJECTED") {} catch {}
            }
        }

        emit DisputeSettledByOracle(_disputeId, d.currentState, _resolutionHash);
    }
}

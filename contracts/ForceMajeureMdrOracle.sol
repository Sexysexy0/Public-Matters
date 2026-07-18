// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IAuditHistory.sol";

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
            (bool success1, ) = payable(d.affectedPartyNode).call{value: settlementCapital}("");
            require(success1, "Transfer failed");
        } else {
            d.currentState = DisputeState.RejectedHoldup;
            (bool success2, ) = payable(sovereignContractor).call{value: settlementCapital}("");
            require(success2, "Transfer failed");

            if (address(auditHistory) != address(0)) {
                try auditHistory.logHistoricalAction(d.affectedPartyNode, 0, 0, 1, "FORCE_MAJEURE_HOLDUP_REJECTED") {} catch {}
            }
        }
        emit DisputeSettledByOracle(_disputeId, d.currentState, _resolutionHash);
    }
}

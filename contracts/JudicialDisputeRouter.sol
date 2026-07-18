// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IAuditHistory.sol";

contract JudicialDisputeRouter {
    address public sovereignContractor;
    IAuditHistory public auditHistory;
    uint256 public totalDisputes;

    enum MediationStatus { UnderMediation, Settled, Disapproved, Refused }

    struct DisputeCase {
        uint256 id;
        address claimant;
        address respondent;
        uint256 escrowedFunds;
        MediationStatus status;
        address appointedMediator;
        bytes32 caseResolutionHash;
    }

    mapping(uint256 => DisputeCase) public disputes;
    mapping(address => bool) public certifiedMediators;

    event DisputeReferred(uint256 indexed disputeId, address indexed claimant, address indexed respondent, uint256 funds);
    event MediationSettled(uint256 indexed disputeId, address indexed mediator, bytes32 resolutionHash);
    event MediationTerminated(uint256 indexed disputeId, MediationStatus indexed finalStatus);
    event MediatorStatusUpdated(address indexed mediator, bool status);

    modifier onlyContractor() {
        require(msg.sender == sovereignContractor, "Error: Access denied. Only the Sovereign Contractor can configure mediation routers.");
        _;
    }

    modifier onlyAppointedMediator(uint256 _disputeId) {
        require(certifiedMediators[msg.sender], "Error: Node is not a certified mediator in the registry.");
        require(disputes[_disputeId].appointedMediator == msg.sender, "Error: Unauthorized. You are not the appointed mediator for this case.");
        _;
    }

    constructor() {
        sovereignContractor = msg.sender;
    }

    function setAuditHistoryAddress(address _auditHistoryAddress) public onlyContractor {
        auditHistory = IAuditHistory(_auditHistoryAddress);
    }

    function setMediatorClearance(address _mediator, bool _status) public onlyContractor {
        certifiedMediators[_mediator] = _status;
        emit MediatorStatusUpdated(_mediator, _status);
    }

    function referToMediation(address _respondent, address _mediator) public payable returns (uint256) {
        require(msg.value > 0, "Error: Escrowed mediation funds must be greater than zero.");
        require(_respondent != address(0) && _mediator != address(0), "Error: Invalid counterpart or mediator node.");
        require(certifiedMediators[_mediator], "Error: Selected mediator node holds no corporate clearance.");

        totalDisputes++;
        disputes[totalDisputes] = DisputeCase({
            id: totalDisputes,
            claimant: msg.sender,
            respondent: _respondent,
            escrowedFunds: msg.value,
            status: MediationStatus.UnderMediation,
            appointedMediator: _mediator,
            caseResolutionHash: bytes32(0)
        });

        emit DisputeReferred(totalDisputes, msg.sender, _respondent, msg.value);
        return totalDisputes;
    }

    function executeCompromiseSettlement(
        uint256 _disputeId,
        uint256 _claimantPayout,
        uint256 _respondentPayout,
        bytes32 _resolutionHash
    ) public onlyAppointedMediator(_disputeId) {
        DisputeCase storage c = disputes[_disputeId];
        require(c.status == MediationStatus.UnderMediation, "Error: Mediation case is already closed or inactive.");
        require(_claimantPayout + _respondentPayout == c.escrowedFunds, "Error: Discrepancy identified in settlement fund allocation mapping.");

        c.status = MediationStatus.Settled;
        c.caseResolutionHash = _resolutionHash;
        c.escrowedFunds = 0;

        if (_claimantPayout > 0) {
            (bool success1, ) = payable(c.claimant).call{value: _claimantPayout}("");
            require(success1, "Transfer failed");
        }
        if (_respondentPayout > 0) {
            (bool success2, ) = payable(c.respondent).call{value: _respondentPayout}("");
            require(success2, "Transfer failed");
        }

        emit MediationSettled(_disputeId, msg.sender, _resolutionHash);

        if (address(auditHistory) != address(0)) {
            try auditHistory.logHistoricalAction(c.claimant, 0, 1, 0, _resolutionHash) {} catch {}
        }
    }

    function terminateFailedMediation(uint256 _disputeId, bool _isRefused) public onlyAppointedMediator(_disputeId) {
        DisputeCase storage c = disputes[_disputeId];
        require(c.status == MediationStatus.UnderMediation, "Error: Case is already closed.");

        MediationStatus finalStatus = _isRefused ? MediationStatus.Refused : MediationStatus.Disapproved;
        c.status = finalStatus;

        uint256 refundAmount = c.escrowedFunds;
        c.escrowedFunds = 0;

        (bool success, ) = payable(c.claimant).call{value: refundAmount}("");
        require(success, "Refund failed");

        emit MediationTerminated(_disputeId, finalStatus);
    }
}

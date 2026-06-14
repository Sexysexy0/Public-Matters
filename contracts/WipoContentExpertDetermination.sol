// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./IAuditHistory.sol";

contract WipoContentExpertDetermination {
    address public sovereignContractor;
    IAuditHistory public auditHistory;
    
    uint256 public totalDisputes;

    enum ADRStatus { UnderReview, Upheld, Reversed, Terminated }

    struct DisputeCase {
        uint256 id;
        address contentProvider;
        bytes32 contentHashId;
        address appointedWipoExpert;
        ADRStatus status;
        bytes32 resolutionHash;
    }

    mapping(uint256 => DisputeCase) public disputes;
    mapping(address => bool) public certifiedWipoExperts;

    event DisputeOpened(uint256 indexed caseId, address indexed provider, bytes32 contentHash);
    event DisputeResolved(uint256 indexed caseId, ADRStatus indexed finalStatus, bytes32 resolutionHash);
    event ExpertStatusUpdated(address indexed expert, bool status);

    modifier onlyContractor() {
        require(msg.sender == sovereignContractor, "Error: Only Sovereign Contractor access.");
        _;
    }

    modifier onlyAppointedExpert(uint256 _caseId) {
        require(certifiedWipoExperts[msg.sender], "Error: Node is not a certified expert.");
        require(disputes[_caseId].appointedWipoExpert == msg.sender, "Error: Unauthorized expert allocation.");
        _;
    }

    constructor() {
        sovereignContractor = msg.sender;
    }

    function setAuditHistoryAddress(address _auditHistoryAddress) public onlyContractor {
        auditHistory = IAuditHistory(_auditHistoryAddress);
    }

    function setExpertClearance(address _expert, bool _status) public onlyContractor {
        certifiedWipoExperts[_expert] = _status;
        emit ExpertStatusUpdated(_expert, _status);
    }

    function openContentADR(
        address _provider,
        bytes32 _contentHash,
        address _expert
    ) public onlyContractor returns (uint256) {
        require(certifiedWipoExperts[_expert], "Error: Allocated target expert holds no legal clearance.");
        totalDisputes++;
        
        disputes[totalDisputes] = DisputeCase({
            id: totalDisputes,
            contentProvider: _provider,
            contentHashId: _contentHash,
            appointedWipoExpert: _expert,
            status: ADRStatus.UnderReview,
            resolutionHash: bytes32(0)
        });

        emit DisputeOpened(totalDisputes, _provider, _contentHash);
        return totalDisputes;
    }

    /**
     * @dev WIPO ARTICLE 17(9) EXPERT RESOLUTION FLOW: Ang sertipikadong nyutral na eksperto 
     * ang siyang maglalapat ng selyadong pasya (Upheld o Reversed) sa network parameters.
     */
    function resolveContentADR(
        uint256 _caseId,
        bool _willUpheld,
        bytes32 _resolutionHash
    ) public onlyAppointedExpert(_caseId) {
        DisputeCase storage c = disputes[_caseId];
        require(c.status == ADRStatus.UnderReview, "Error: Target dispute lifecycle already closed.");

        c.status = _willUpheld ? ADRStatus.Upheld : ADRStatus.Reversed;
        c.resolutionHash = _resolutionHash;

        emit DisputeResolved(_caseId, c.status, _resolutionHash);

        if (address(auditHistory) != address(0)) {
            try auditHistory.logHistoricalAction(c.contentProvider, 0, 1, 0, _resolutionHash) {} catch {}
        }
    }
}

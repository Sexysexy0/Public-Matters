// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title DisputeResolutionArbitration
 * @dev Silent arbitration ledger for treaty and PPP conflicts
 */
contract DisputeResolutionArbitration {
    address public immutable owner;

    enum DisputeStatus { NONE, DISPUTED, RESOLVED }

    struct Dispute {
        uint256 treatyId;       // Reference to TokenizedTreatyBase ID
        address disputant;      // Who raised the issue
        address respondent;     // Who is being disputed against
        bytes32 evidenceHash;   // Hash of the off-chain evidence document
        DisputeStatus status;   // Current state of the dispute
        uint256 timestamp;      // When it was raised
    }

    uint256 public disputeCount;
    mapping(uint256 => Dispute) public disputes;

    event DisputeRaised(uint256 indexed id, uint256 treatyId, address disputant, address respondent);
    event DisputeResolved(uint256 indexed id, bool inFavorOfDisputant);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can arbitrate");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    // Submit a new dispute
    function raiseDispute(
        uint256 _treatyId,
        address _respondent,
        bytes32 _evidenceHash
    ) external onlyOwner returns (uint256) {
        require(_respondent != address(0), "Invalid respondent");
        require(_evidenceHash != bytes32(0), "Evidence hash required");

        disputeCount++;
        disputes[disputeCount] = Dispute({
            treatyId: _treatyId,
            disputant: msg.sender, // The owner (you) are the default disputant for now
            respondent: _respondent,
            evidenceHash: _evidenceHash,
            status: DisputeStatus.DISPUTED,
            timestamp: block.timestamp
        });

        emit DisputeRaised(disputeCount, _treatyId, msg.sender, _respondent);
        return disputeCount;
    }

    // Resolve a dispute (Owner's final word)
    function resolveDispute(uint256 _disputeId, bool _inFavorOfDisputant) external onlyOwner {
        Dispute storage dispute = disputes[_disputeId];
        require(dispute.status == DisputeStatus.DISPUTED, "Dispute not active");

        dispute.status = DisputeStatus.RESOLVED;
        emit DisputeResolved(_disputeId, _inFavorOfDisputant);
    }

    function getDispute(uint256 _id) external view returns (Dispute memory) {
        return disputes[_id];
    }
}

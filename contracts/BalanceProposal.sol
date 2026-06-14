// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title BalanceProposal
/// @notice Covenant to encode community feedback for N-TWO operator balance
contract BalanceProposal {
    address public overseer;
    uint256 public proposalCount;

    struct FeedbackRecord {
        uint256 id;
        string source;       // community comment, dev forum, etc.
        string issue;        // OP freeze, vehicle abuse, stacking
        string suggestion;   // slow effect, grenade limit, stacking cap
        string mode;         // Operations, Warfare, Vehicles
        uint256 timestamp;
    }

    mapping(uint256 => FeedbackRecord) public records;

    event FeedbackLogged(uint256 indexed id, string source, string issue, string suggestion, string mode);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs balance feedback record
    function logFeedback(string calldata source, string calldata issue, string calldata suggestion, string calldata mode) external onlyOverseer {
        proposalCount++;
        records[proposalCount] = FeedbackRecord({
            id: proposalCount,
            source: source,
            issue: issue,
            suggestion: suggestion,
            mode: mode,
            timestamp: block.timestamp
        });
        emit FeedbackLogged(proposalCount, source, issue, suggestion, mode);
    }

    /// @notice Citizens can view balance feedback records
    function viewFeedback(uint256 id) external view returns (FeedbackRecord memory) {
        return records[id];
    }
}

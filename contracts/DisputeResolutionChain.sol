// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title DisputeResolutionChain
/// @notice Fairness trail for resolving tax refund disputes
contract DisputeResolutionChain {
    address public oversightCommittee;
    uint256 public disputeCount;

    struct Dispute {
        uint256 id;
        address taxpayer;
        string issue;
        string resolution;
        bool resolved;
        uint256 timestamp;
    }

    mapping(uint256 => Dispute) public disputes;

    event DisputeFiled(uint256 indexed id, address indexed taxpayer, string issue);
    event DisputeResolved(uint256 indexed id, string resolution);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Taxpayer files a dispute
    function fileDispute(string calldata issue) external {
        disputeCount++;
        disputes[disputeCount] = Dispute({
            id: disputeCount,
            taxpayer: msg.sender,
            issue: issue,
            resolution: "",
            resolved: false,
            timestamp: block.timestamp
        });
        emit DisputeFiled(disputeCount, msg.sender, issue);
    }

    /// @notice Oversight Committee resolves dispute
    function resolveDispute(uint256 id, string calldata resolution) external onlyOversight {
        Dispute storage d = disputes[id];
        require(!d.resolved, "Already resolved");
        d.resolved = true;
        d.resolution = resolution;
        emit DisputeResolved(id, resolution);
    }

    /// @notice Citizens can view dispute details
    function viewDispute(uint256 id) external view returns (Dispute memory) {
        return disputes[id];
    }
}

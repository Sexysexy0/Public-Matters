// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title RefundEscrow
/// @notice Escrow covenant for community-oriented tax refunds
contract RefundEscrow {
    address public oversightCommittee;
    uint256 public refundCount;

    struct Refund {
        uint256 id;
        address taxpayer;
        uint256 amount;
        bool released;
        uint256 timestamp;
    }

    mapping(uint256 => Refund) public refunds;

    event RefundFiled(uint256 indexed id, address indexed taxpayer, uint256 amount);
    event RefundReleased(uint256 indexed id, address indexed taxpayer, uint256 amount);
    event CommunityAllocation(uint256 indexed id, uint256 amount);

    modifier onlyOversight() {
        require(msg.sender == oversightCommittee, "Not authorized");
        _;
    }

    constructor(address _oversightCommittee) {
        oversightCommittee = _oversightCommittee;
    }

    /// @notice Oversight Committee files refund claim
    function fileRefund(address taxpayer, uint256 amount) external onlyOversight {
        refundCount++;
        refunds[refundCount] = Refund({
            id: refundCount,
            taxpayer: taxpayer,
            amount: amount,
            released: false,
            timestamp: block.timestamp
        });
        emit RefundFiled(refundCount, taxpayer, amount);
    }

    /// @notice Release refund directly to taxpayer
    function releaseRefund(uint256 id) external onlyOversight {
        Refund storage r = refunds[id];
        require(!r.released, "Already released");
        r.released = true;
        emit RefundReleased(id, r.taxpayer, r.amount);
    }

    /// @notice Allocate refund to community fund instead of individual payout
    function allocateToCommunity(uint256 id) external onlyOversight {
        Refund storage r = refunds[id];
        require(!r.released, "Already released");
        r.released = true;
        emit CommunityAllocation(id, r.amount);
    }
}

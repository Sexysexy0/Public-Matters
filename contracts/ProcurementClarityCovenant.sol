// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * Procurement Clarity Covenant
 * Purpose: Ensure transparency in public procurement and contracts
 * Effect: Records all bids, awards, and contracts on-chain
 * Safeguard: Governance-controlled approvals, transparent event logging
 */

contract ProcurementClarityCovenant {
    address public governanceBody;

    struct Bid {
        address bidder;
        uint256 amount;
        bool awarded;
    }

    mapping(uint256 => Bid) public bids;
    uint256 public bidCount;

    event BidSubmitted(uint256 indexed id, address bidder, uint256 amount);
    event BidAwarded(uint256 indexed id, address bidder, uint256 amount);

    modifier onlyGovernance() {
        require(msg.sender == governanceBody, "Not authorized");
        _;
    }

    constructor() {
        governanceBody = msg.sender;
    }

    function submitBid(uint256 amount) external {
        bidCount++;
        bids[bidCount] = Bid(msg.sender, amount, false);
        emit BidSubmitted(bidCount, msg.sender, amount);
    }

    function awardBid(uint256 id) external onlyGovernance {
        require(id <= bidCount, "Invalid bid ID");
        bids[id].awarded = true;
        emit BidAwarded(id, bids[id].bidder, bids[id].amount);
    }

    function getBid(uint256 id) external view returns (address, uint256, bool) {
        Bid memory b = bids[id];
        return (b.bidder, b.amount, b.awarded);
    }
}

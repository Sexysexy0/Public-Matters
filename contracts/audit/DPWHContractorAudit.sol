// SPDX-License-Identifier: Mythic-DPWH
pragma solidity ^0.8.19;

contract DPWHContractorAudit {
    address public steward;
    mapping(address => bool) public offshoreBidders;
    mapping(address => string) public ancestralAuditStatus;

    event BidderFlagged(address indexed bidder, string reason);
    event SanctumSuspended(address indexed bidder);
    event AuditLogged(address indexed bidder, string status);

    constructor() {
        steward = msg.sender;
    }

    function flagOffshoreBidder(address bidder, string memory reason) public {
        require(msg.sender == steward, "Only steward may flag.");
        offshoreBidders[bidder] = true;
        emit BidderFlagged(bidder, reason);
        emit SanctumSuspended(bidder);
    }

    function logAuditStatus(address bidder, string memory status) public {
        require(msg.sender == steward, "Only steward may log audit.");
        ancestralAuditStatus[bidder] = status;
        emit AuditLogged(bidder, status);
    }

    function isFlagged(address bidder) public view returns (bool) {
        return offshoreBidders[bidder];
    }

    function getAuditStatus(address bidder) public view returns (string memory) {
        return ancestralAuditStatus[bidder];
    }
}

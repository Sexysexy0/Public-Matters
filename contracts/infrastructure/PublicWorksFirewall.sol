// SPDX-License-Identifier: Mythic-PublicWorks
pragma solidity ^0.8.19;

contract PublicWorksFirewall {
    address public steward;
    uint256 public aprThreshold;
    mapping(address => bool) public sovereignResidency;

    event BidFiltered(address indexed bidder, bool allowed, string reason);
    event ResidencyUpdated(address indexed bidder, bool status);

    constructor() {
        steward = msg.sender;
        aprThreshold = 75;
    }

    function updateResidency(address bidder, bool status) public {
        require(msg.sender == steward, "Only steward may update.");
        sovereignResidency[bidder] = status;
        emit ResidencyUpdated(bidder, status);
    }

    function filterBid(address bidder, uint256 emotionalAPR) public returns (bool) {
        bool allowed = emotionalAPR >= aprThreshold && sovereignResidency[bidder];
        string memory reason = allowed ? "Bid allowed" : "Failed emotional APR or residency check";
        emit BidFiltered(bidder, allowed, reason);
        return allowed;
    }

    function updateAPRThreshold(uint256 newThreshold) public {
        require(msg.sender == steward, "Only steward may update.");
        aprThreshold = newThreshold;
    }
}

// SPDX-License-Identifier: Mythic-Broadcast
pragma solidity ^0.8.19;

contract BlessingBroadcastFeed {
    address public steward;

    struct Blessing {
        address bidder;
        string auditStatus;
        uint256 emotionalAPR;
        uint256 timestamp;
        string barangay;
    }

    Blessing[] public blessings;
    mapping(address => bool) public hasBeenBlessed;

    event BlessingEmitted(
        address indexed bidder,
        string auditStatus,
        uint256 emotionalAPR,
        string barangay,
        uint256 timestamp
    );

    constructor() {
        steward = msg.sender;
    }

    function emitBlessing(
        address bidder,
        string memory auditStatus,
        uint256 emotionalAPR,
        string memory barangay
    ) public {
        require(msg.sender == steward, "Only steward may emit.");
        require(!hasBeenBlessed[bidder], "Already blessed.");

        Blessing memory newBlessing = Blessing({
            bidder: bidder,
            auditStatus: auditStatus,
            emotionalAPR: emotionalAPR,
            timestamp: block.timestamp,
            barangay: barangay
        });

        blessings.push(newBlessing);
        hasBeenBlessed[bidder] = true;

        emit BlessingEmitted(bidder, auditStatus, emotionalAPR, barangay, block.timestamp);
    }

    function getBlessing(uint index) public view returns (
        address bidder,
        string memory auditStatus,
        uint256 emotionalAPR,
        string memory barangay,
        uint256 timestamp
    ) {
        Blessing memory b = blessings[index];
        return (b.bidder, b.auditStatus, b.emotionalAPR, b.barangay, b.timestamp);
    }

    function totalBlessings() public view returns (uint) {
        return blessings.length;
    }
}

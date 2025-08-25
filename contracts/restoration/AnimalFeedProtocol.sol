// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract AnimalFeedProtocol {
    address public steward;

    struct FeedEvent {
        address feeder;
        string animalType;
        string location;
        string feedType;
        string emotionalAPR;
        bool kinshipAttempted;
        uint256 timestamp;
    }

    FeedEvent[] public feedLog;

    event AnimalFed(
        address indexed feeder,
        string animalType,
        string location,
        string feedType,
        string emotionalAPR,
        bool kinshipAttempted,
        uint256 timestamp
    );

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function logFeedEvent(
        string memory animalType,
        string memory location,
        string memory feedType,
        string memory emotionalAPR,
        bool kinshipAttempted
    ) public {
        feedLog.push(FeedEvent(
            msg.sender,
            animalType,
            location,
            feedType,
            emotionalAPR,
            kinshipAttempted,
            block.timestamp
        ));

        emit AnimalFed(
            msg.sender,
            animalType,
            location,
            feedType,
            emotionalAPR,
            kinshipAttempted,
            block.timestamp
        );
    }

    function getFeedLog() public view returns (FeedEvent[] memory) {
        return feedLog;
    }
}

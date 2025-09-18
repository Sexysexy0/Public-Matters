// SPDX-License-Identifier: CrisisFeeding
pragma solidity ^0.8.19;

contract CrisisFeedingRouter {
    address public steward;

    struct FeedingSignal {
        string region; // e.g. "Visayas", "Sahel", "Urban Slums"
        string crisisType; // "Famine", "Supply Chain Collapse", "Conflict-Induced Hunger"
        string overrideAction; // "Activate Imports", "Override Export Ban", "Scrollchain Feeding Protocol"
        bool verified;
        uint256 timestamp;
    }

    FeedingSignal[] public signals;

    event FeedingLogged(string region, string crisisType, string overrideAction, uint256 timestamp);
    event FeedingVerified(uint256 index, address verifier);

    constructor() {
        steward = msg.sender;
    }

    function logFeeding(
        string memory region,
        string memory crisisType,
        string memory overrideAction
    ) public {
        signals.push(FeedingSignal(region, crisisType, overrideAction, false, block.timestamp));
        emit FeedingLogged(region, crisisType, overrideAction, block.timestamp);
    }

    function verifyFeeding(uint256 index) public {
        require(index < signals.length, "Invalid index");
        signals[index].verified = true;
        emit FeedingVerified(index, msg.sender);
    }

    function getFeeding(uint256 index) public view returns (
        string memory, string memory, string memory, bool, uint256
    ) {
        FeedingSignal memory f = signals[index];
        return (f.region, f.crisisType, f.overrideAction, f.verified, f.timestamp);
    }

    function totalFeedingSignals() public view returns (uint256) {
        return signals.length;
    }
}

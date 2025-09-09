// SPDX-License-Identifier: JudicialReviewTrigger-License
pragma solidity ^0.8.0;

contract JudicialReviewTriggerOracle {
    address public steward;

    struct ReviewSignal {
        string clauseID;
        string breachType;
        string respondent;
        bool reviewTriggered;
        uint256 timestamp;
    }

    ReviewSignal[] public signals;

    event ReviewTriggered(string clauseID, string breachType, string respondent, bool reviewTriggered, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function triggerReview(string memory clauseID, string memory breachType, string memory respondent, bool reviewTriggered) public {
        require(msg.sender == steward, "Only steward can trigger");
        signals.push(ReviewSignal(clauseID, breachType, respondent, reviewTriggered, block.timestamp));
        emit ReviewTriggered(clauseID, breachType, respondent, reviewTriggered, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, string memory, bool, uint256) {
        ReviewSignal memory s = signals[index];
        return (s.clauseID, s.breachType, s.respondent, s.reviewTriggered, s.timestamp);
    }
}

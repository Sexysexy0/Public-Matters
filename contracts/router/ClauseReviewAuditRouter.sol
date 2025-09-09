// SPDX-License-Identifier: ClauseReviewAudit-License
pragma solidity ^0.8.0;

contract ClauseReviewAuditRouter {
    address public steward;

    struct ReviewSignal {
        string clauseID;
        string breachType;
        string respondent;
        bool reviewConfirmed;
        uint256 timestamp;
    }

    ReviewSignal[] public signals;

    event ClauseReviewRouted(string clauseID, string breachType, string respondent, bool reviewConfirmed, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeReview(string memory clauseID, string memory breachType, string memory respondent, bool reviewConfirmed) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(ReviewSignal(clauseID, breachType, respondent, reviewConfirmed, block.timestamp));
        emit ClauseReviewRouted(clauseID, breachType, respondent, reviewConfirmed, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, string memory, bool, uint256) {
        ReviewSignal memory s = signals[index];
        return (s.clauseID, s.breachType, s.respondent, s.reviewConfirmed, s.timestamp);
    }
}

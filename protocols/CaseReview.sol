// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// CaseReview: log reviews and decisions by IPC
contract CaseReview {
    struct Review {
        uint256 id;
        uint256 petitionId;
        address reviewer;
        string findingsURI;
        bool violationConfirmed;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Review) public reviews;
    mapping(address => bool) public reviewers;
    address public steward;

    event ReviewLogged(uint256 indexed id, uint256 petitionId, bool violationConfirmed);

    constructor() {
        steward = msg.sender;
        reviewers[steward] = true;
    }

    function addReviewer(address r) external {
        require(msg.sender == steward, "Only steward");
        reviewers[r] = true;
    }

    function logReview(uint256 petitionId, string calldata findingsURI, bool violationConfirmed) external {
        require(reviewers[msg.sender], "Not reviewer");
        reviews[nextId] = Review(nextId, petitionId, msg.sender, findingsURI, violationConfirmed, block.timestamp);
        emit ReviewLogged(nextId, petitionId, violationConfirmed);
        nextId++;
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// AntiCaptureGuard: challenge flags + review outcomes
contract AntiCaptureGuard {
    struct Challenge {
        uint256 id;
        uint256 partyId;
        address challenger;
        string reasonURI;   // documentation or investigative memo
        bool resolved;
        bool upheld;        // true if challenge upheld (capture confirmed)
        uint256 timestamp;
    }

    address public steward;
    mapping(address => bool) public reviewers;
    uint256 public nextChallengeId;
    mapping(uint256 => Challenge) public challenges;

    event ReviewerAdded(address indexed reviewer);
    event Challenged(uint256 indexed id, uint256 indexed partyId);
    event Resolved(uint256 indexed id, bool upheld);

    constructor() {
        steward = msg.sender;
        reviewers[steward] = true;
        emit ReviewerAdded(steward);
    }

    function addReviewer(address _reviewer) external {
        require(msg.sender == steward, "Only steward");
        reviewers[_reviewer] = true;
        emit ReviewerAdded(_reviewer);
    }

    function fileChallenge(uint256 _partyId, string calldata _reasonURI) external {
        challenges[nextChallengeId] = Challenge(
            nextChallengeId,
            _partyId,
            msg.sender,
            _reasonURI,
            false,
            false,
            block.timestamp
        );
        emit Challenged(nextChallengeId, _partyId);
        nextChallengeId++;
    }

    function resolveChallenge(uint256 _id, bool _upheld) external {
        require(reviewers[msg.sender], "Not reviewer");
        require(!challenges[_id].resolved, "Already resolved");
        challenges[_id].resolved = true;
        challenges[_id].upheld = _upheld;
        emit Resolved(_id, _upheld);
    }

    function isFlagged(uint256 _partyId) external view returns (bool flagged) {
        for (uint256 i = 0; i < nextChallengeId; i++) {
            Challenge memory c = challenges[i];
            if (c.partyId == _partyId && c.resolved && c.upheld) return true;
        }
        return false;
    }
}

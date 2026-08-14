// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PeerReviewOracle {
    struct Review {
        bytes32 studyId;
        bytes32 reviewHash;
        uint256 timestamp;
        address reviewer;
        bool isReplicated;
    }

    mapping(bytes32 => Review) public reviews;
    bytes32[] public reviewIds;

    event ReviewSubmitted(bytes32 indexed reviewId, bytes32 indexed studyId);

    function submitReview(
        bytes32 _reviewId,
        bytes32 _studyId,
        bytes32 _reviewHash,
        bool _isReplicated
    ) external {
        require(reviews[_reviewId].reviewer == address(0), "Review already exists");
        reviews[_reviewId] = Review({
            studyId: _studyId,
            reviewHash: _reviewHash,
            timestamp: block.timestamp,
            reviewer: msg.sender,
            isReplicated: _isReplicated
        });
        reviewIds.push(_reviewId);
        emit ReviewSubmitted(_reviewId, _studyId);
    }

    function getReplicationStatus(bytes32 _studyId) external view returns (bool) {
        // Simplified: returns true if at least one review says replicated
        for (uint i = 0; i < reviewIds.length; i++) {
            if (reviews[reviewIds[i]].studyId == _studyId && reviews[reviewIds[i]].isReplicated) {
                return true;
            }
        }
        return false;
    }
}

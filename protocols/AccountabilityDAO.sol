// AccountabilityDAO.sol
pragma solidity ^0.8.0;

contract AccountabilityDAO {
    struct Review {
        uint256 id;
        string subject;   // e.g. "Senate Oversight"
        string detail;    // e.g. "ICC Compliance"
        uint256 votesFor;
        uint256 votesAgainst;
        bool ratified;
    }

    uint256 public reviewCount;
    mapping(uint256 => Review) public reviews;

    event ReviewCreated(uint256 id, string subject, string detail);
    event ReviewVoted(uint256 id, string subject, bool support);
    event ReviewRatified(uint256 id, string subject);
    event AccountabilityDeclared(string message);

    function createReview(string memory subject, string memory detail) public {
        reviewCount++;
        reviews[reviewCount] = Review(reviewCount, subject, detail, 0, 0, false);
        emit ReviewCreated(reviewCount, subject, detail);
    }

    function voteReview(uint256 id, bool support) public {
        if (support) {
            reviews[id].votesFor++;
        } else {
            reviews[id].votesAgainst++;
        }
        emit ReviewVoted(id, reviews[id].subject, support);
    }

    function ratifyReview(uint256 id) public {
        Review storage r = reviews[id];
        require(!r.ratified, "Already ratified");
        require(r.votesFor > r.votesAgainst, "Not enough support");
        r.ratified = true;
        emit ReviewRatified(r.id, r.subject);
    }

    function declareAccountability() public {
        emit AccountabilityDeclared("Accountability DAO: safeguard arcs encoded into communal consequence.");
    }
}

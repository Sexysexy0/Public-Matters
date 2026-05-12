// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ReviewEquityOracle {
    struct ReviewEquity {
        address overseer;
        string title;
        string safeguard;
        uint256 timestamp;
        bool safeguarded;
    }

    ReviewEquity[] public reviews;

    event ReviewLogged(address indexed overseer, string title, string safeguard);
    event ReviewSafeguarded(uint256 indexed id, address verifier);

    function logReview(string memory _title, string memory _safeguard) public {
        reviews.push(ReviewEquity(msg.sender, _title, _safeguard, block.timestamp, false));
        emit ReviewLogged(msg.sender, _title, _safeguard);
    }

    function safeguardReview(uint256 _id) public {
        require(_id < reviews.length, "Invalid ID");
        reviews[_id].safeguarded = true;
        emit ReviewSafeguarded(_id, msg.sender);
    }

    function getReview(uint256 _id) public view returns (ReviewEquity memory) {
        require(_id < reviews.length, "Invalid ID");
        return reviews[_id];
    }

    function totalReviews() public view returns (uint256) {
        return reviews.length;
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title CommunityCrashCodex
/// @notice Covenant contract encoding gamer sentiment safeguards and industry reset decrees
contract CommunityCrashCodex {
    address public owner;

    struct Sentiment {
        uint256 commentId; // linked to community comment
        string domain;     // e.g. "Bad Writing", "Modern Audience", "Investor Pressure", "Indie Guardianship"
        string decree;     // safeguard decree text
        uint256 timestamp;
    }

    Sentiment[] public sentiments;

    event Decreed(uint256 commentId, string domain, string decree, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Encode community sentiment into covenant safeguard
    function decreeSentiment(uint256 commentId, string memory domain, string memory decree) public onlyOwner {
        Sentiment memory newSentiment = Sentiment(commentId, domain, decree, block.timestamp);
        sentiments.push(newSentiment);
        emit Decreed(commentId, domain, decree, block.timestamp);
    }

    function getSentiment(uint256 index) public view returns (uint256, string memory, string memory, uint256) {
        Sentiment memory s = sentiments[index];
        return (s.commentId, s.domain, s.decree, s.timestamp);
    }

    function getSentimentCount() public view returns (uint256) {
        return sentiments.length;
    }
}

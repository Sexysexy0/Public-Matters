// MarketSentimentDAO.sol
pragma solidity ^0.8.0;

contract MarketSentimentDAO {
    struct Sentiment {
        uint256 id;
        string asset;     // e.g. "BTC"
        string mood;      // e.g. "Bearish", "Bullish"
        uint256 votesFor;
        uint256 votesAgainst;
        bool ratified;
    }

    uint256 public sentimentCount;
    mapping(uint256 => Sentiment) public sentiments;

    event SentimentCreated(uint256 id, string asset, string mood);
    event SentimentVoted(uint256 id, string asset, bool support);
    event SentimentRatified(uint256 id, string asset);
    event SentimentDeclared(string message);

    function createSentiment(string memory asset, string memory mood) public {
        sentimentCount++;
        sentiments[sentimentCount] = Sentiment(sentimentCount, asset, mood, 0, 0, false);
        emit SentimentCreated(sentimentCount, asset, mood);
    }

    function voteSentiment(uint256 id, bool support) public {
        if (support) {
            sentiments[id].votesFor++;
        } else {
            sentiments[id].votesAgainst++;
        }
        emit SentimentVoted(id, sentiments[id].asset, support);
    }

    function ratifySentiment(uint256 id) public {
        Sentiment storage s = sentiments[id];
        require(!s.ratified, "Already ratified");
        require(s.votesFor > s.votesAgainst, "Not enough support");
        s.ratified = true;
        emit SentimentRatified(s.id, s.asset);
    }

    function declareSentiment() public {
        emit SentimentDeclared("Market Sentiment DAO: safeguard arcs encoded into communal consequence.");
    }
}

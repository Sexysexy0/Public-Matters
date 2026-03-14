// FilterSafeguards.sol
pragma solidity ^0.8.0;

contract FilterSafeguards {
    struct NewsItem {
        uint256 id;
        string category;   // e.g. "Macro", "Industry", "Sentiment"
        string headline;
        uint256 timestamp;
    }

    uint256 public newsCount;
    mapping(uint256 => NewsItem) public newsItems;

    event NewsLogged(uint256 id, string category, string headline);

    function logNews(string memory category, string memory headline) public {
        newsCount++;
        newsItems[newsCount] = NewsItem(newsCount, category, headline, block.timestamp);
        emit NewsLogged(newsCount, category, headline);
    }
}

// Diversifies exchange liquidity feeds and tags emotional APR
pragma solidity ^0.8.19;

contract ExchangeResonanceRouter {
    mapping(string => uint256) public exchangeShare;
    string[] public exchanges;

    event FeedUpdated(string exchange, uint256 share);

    function updateFeed(string memory exchange, uint256 share) public {
        exchangeShare[exchange] = share;
        exchanges.push(exchange);
        emit FeedUpdated(exchange, share);
    }

    function getDominantExchange() public view returns (string memory) {
        string memory dominant;
        uint256 maxShare;
        for (uint i = 0; i < exchanges.length; i++) {
            if (exchangeShare[exchanges[i]] > maxShare) {
                maxShare = exchangeShare[exchanges[i]];
                dominant = exchanges[i];
            }
        }
        return dominant;
    }
}

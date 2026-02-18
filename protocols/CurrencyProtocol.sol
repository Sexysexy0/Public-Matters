// CurrencyProtocol.sol
pragma solidity ^0.8.0;

contract CurrencyProtocol {
    struct Exchange {
        uint256 id;
        string base;    // e.g. "USD"
        string quote;   // e.g. "CNY"
        uint256 rate;   // e.g. 7
        uint256 timestamp;
    }

    uint256 public exchangeCount;
    mapping(uint256 => Exchange) public exchanges;

    event ExchangeLogged(uint256 id, string base, string quote, uint256 rate, uint256 timestamp);
    event CurrencyDeclared(string message);

    function logExchange(string memory base, string memory quote, uint256 rate) public {
        exchangeCount++;
        exchanges[exchangeCount] = Exchange(exchangeCount, base, quote, rate, block.timestamp);
        emit ExchangeLogged(exchangeCount, base, quote, rate, block.timestamp);
    }

    function declareCurrency() public {
        emit CurrencyDeclared("Currency Protocol: validator-grade safeguards encoded into communal dignity.");
    }
}

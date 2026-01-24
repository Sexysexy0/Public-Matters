pragma solidity ^0.8.20;

contract ETFIntegrationProtocol {
    address public admin;

    struct ETF {
        string provider;     // e.g. BlackRock, Coinbase, Ark Invest
        string typeOf;       // e.g. spot BTC ETF, futures ETF
        string effect;       // e.g. institutional access, liquidity boost
        uint256 timestamp;
    }

    ETF[] public etfs;

    event ETFLogged(string provider, string typeOf, string effect, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logETF(string calldata provider, string calldata typeOf, string calldata effect) external onlyAdmin {
        etfs.push(ETF(provider, typeOf, effect, block.timestamp));
        emit ETFLogged(provider, typeOf, effect, block.timestamp);
    }

    function totalETFs() external view returns (uint256) {
        return etfs.length;
    }
}

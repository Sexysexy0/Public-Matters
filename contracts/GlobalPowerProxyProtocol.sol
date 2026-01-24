pragma solidity ^0.8.20;

contract GlobalPowerProxyProtocol {
    address public admin;

    struct Proxy {
        string asset;        // e.g. Bitcoin, gold
        string bloc;         // e.g. US dollar system, BRICS
        string narrative;    // e.g. financial dominance, alternative reserve
        uint256 timestamp;
    }

    Proxy[] public proxies;

    event ProxyLogged(string asset, string bloc, string narrative, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logProxy(string calldata asset, string calldata bloc, string calldata narrative) external onlyAdmin {
        proxies.push(Proxy(asset, bloc, narrative, block.timestamp));
        emit ProxyLogged(asset, bloc, narrative, block.timestamp);
    }

    function totalProxies() external view returns (uint256) {
        return proxies.length;
    }
}

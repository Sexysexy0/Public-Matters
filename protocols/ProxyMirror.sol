// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ProxyMirror: record proxy conflicts and rivalries
contract ProxyMirror {
    struct Proxy {
        uint256 id;
        string conflict;    // "US vs Russia in Venezuela"
        string domain;      // "Oil", "Military", "Politics"
        string description;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Proxy) public proxies;
    mapping(address => bool) public stewards;

    event ProxyLogged(uint256 indexed id, string conflict, string domain);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logProxy(string calldata conflict, string calldata domain, string calldata description) external {
        require(stewards[msg.sender], "Only steward");
        proxies[nextId] = Proxy(nextId, conflict, domain, description, block.timestamp);
        emit ProxyLogged(nextId, conflict, domain);
        nextId++;
    }
}

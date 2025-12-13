// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// InfluenceRegistry: record foreign influence in hemisphere
contract InfluenceRegistry {
    struct Influence {
        uint256 id;
        string actor;       // "Russia", "China", "US"
        string method;      // "Military Support", "Economic Aid", "Sanctions"
        string target;      // "Venezuela", "Cuba"
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Influence) public influences;
    mapping(address => bool) public stewards;

    event InfluenceLogged(uint256 indexed id, string actor, string method, string target);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logInfluence(string calldata actor, string calldata method, string calldata target) external {
        require(stewards[msg.sender], "Only steward");
        influences[nextId] = Influence(nextId, actor, method, target, block.timestamp);
        emit InfluenceLogged(nextId, actor, method, target);
        nextId++;
    }
}

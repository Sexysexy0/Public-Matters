// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// AttackRegistry: catalog prompt injection attack vectors
contract AttackRegistry {
    struct Attack {
        uint256 id;
        string vector;      // "Hidden Command", "Indirect Injection"
        string target;      // "Email Agent", "Browser Agent"
        string description;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Attack) public attacks;
    mapping(address => bool) public stewards;

    event AttackLogged(uint256 indexed id, string vector, string target);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logAttack(string calldata vector, string calldata target, string calldata description) external {
        require(stewards[msg.sender], "Only steward");
        attacks[nextId] = Attack(nextId, vector, target, description, block.timestamp);
        emit AttackLogged(nextId, vector, target);
        nextId++;
    }
}

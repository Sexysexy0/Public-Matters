// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// TestPolicyRegistry: declare testing policies per role and substance
contract TestPolicyRegistry {
    struct Policy {
        uint256 id;
        string role;         // e.g., "Warehouse helper", "Forklift operator"
        string substance;    // e.g., "THC", "Alcohol"
        bool required;       // true = mandatory test, false = optional/no test
        string basisURI;     // policy docs, DOLE memos
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Policy) public policies;
    mapping(address => bool) public stewards;

    event PolicySet(uint256 indexed id, string role, string substance, bool required);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function setPolicy(string calldata role, string calldata substance, bool required, string calldata basisURI) external {
        require(stewards[msg.sender], "Only steward");
        policies[nextId] = Policy(nextId, role, substance, required, basisURI, block.timestamp);
        emit PolicySet(nextId, role, substance, required);
        nextId++;
    }

    function updateRequired(uint256 id, bool required) external {
        require(stewards[msg.sender], "Only steward");
        policies[id].required = required;
    }
}

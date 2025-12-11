// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ReliefLedger: track direct reliefs and affordability outcomes
contract ReliefLedger {
    struct Relief {
        uint256 id;
        address beneficiary;
        string category;       // e.g., "Food", "Transport", "Utilities", "Tuition"
        uint256 amount;        // pesos value or subsidy amount
        string evidenceURI;    // receipts, coop statements
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Relief) public reliefs;
    mapping(address => bool) public stewards;

    event ReliefLogged(uint256 indexed id, address beneficiary, string category);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logRelief(address beneficiary, string calldata category, uint256 amount, string calldata evidenceURI) external {
        require(stewards[msg.sender], "Only steward");
        reliefs[nextId] = Relief(nextId, beneficiary, category, amount, evidenceURI, block.timestamp);
        emit ReliefLogged(nextId, beneficiary, category);
        nextId++;
    }
}

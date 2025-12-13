// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// BeneficiaryRegistry: record all living persons as beneficiaries
contract BeneficiaryRegistry {
    struct Beneficiary {
        uint256 id;
        string name;
        uint256 age;
        string coveragePlan;
        bool enrolled;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Beneficiary) public beneficiaries;
    mapping(address => bool) public stewards;

    event BeneficiaryLogged(uint256 indexed id, string name, string coveragePlan);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logBeneficiary(string calldata name, uint256 age, string calldata coveragePlan, bool enrolled) external {
        require(stewards[msg.sender], "Only steward");
        beneficiaries[nextId] = Beneficiary(nextId, name, age, coveragePlan, enrolled, block.timestamp);
        emit BeneficiaryLogged(nextId, name, coveragePlan);
        nextId++;
    }
}

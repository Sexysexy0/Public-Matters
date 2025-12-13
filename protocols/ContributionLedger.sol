// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// ContributionLedger: record flexible contributions
contract ContributionLedger {
    struct Contribution {
        uint256 id;
        address contributor;
        uint256 amount;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Contribution) public contributions;
    mapping(address => bool) public stewards;

    event ContributionLogged(uint256 indexed id, address contributor, uint256 amount);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logContribution(address contributor, uint256 amount) external {
        require(stewards[msg.sender], "Only steward");
        contributions[nextId] = Contribution(nextId, contributor, amount, block.timestamp);
        emit ContributionLogged(nextId, contributor, amount);
        nextId++;
    }
}

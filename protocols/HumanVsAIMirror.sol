// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// HumanVsAIMirror: record comparative outcomes between human and AI code
contract HumanVsAIMirror {
    struct Comparison {
        uint256 id;
        string metric;      // "Issues per PR", "Critical Issues", "Security Risks"
        uint256 humanValue;
        uint256 aiValue;
        string outcome;     // "Humans safer", "AI riskier"
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Comparison) public comparisons;
    mapping(address => bool) public stewards;

    event ComparisonLogged(uint256 indexed id, string metric, uint256 humanValue, uint256 aiValue, string outcome);

    constructor() { stewards[msg.sender] = true; }

    function addSteward(address s) external {
        require(stewards[msg.sender], "Only steward");
        stewards[s] = true;
    }

    function logComparison(string calldata metric, uint256 humanValue, uint256 aiValue, string calldata outcome) external {
        require(stewards[msg.sender], "Only steward");
        comparisons[nextId] = Comparison(nextId, metric, humanValue, aiValue, outcome, block.timestamp);
        emit ComparisonLogged(nextId, metric, humanValue, aiValue, outcome);
        nextId++;
    }
}

pragma solidity ^0.8.20;

contract MergingStrengthsTreaty {
    address public overseer;
    uint256 public treatyCount;

    struct StrengthRule {
        uint256 id;
        string principle;   // Merging Strengths, Synergy
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => StrengthRule) public treaties;
    event StrengthRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareStrengthRule(string calldata principle, string calldata description) external onlyOverseer {
        treatyCount++;
        treaties[treatyCount] = StrengthRule(treatyCount, principle, description, block.timestamp);
        emit StrengthRuleDeclared(treatyCount, principle, description);
    }
}

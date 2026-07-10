pragma solidity ^0.8.20;

contract ReliabilityTreaty {
    address public overseer;
    uint256 public treatyCount;

    struct ReliabilityRule {
        uint256 id;
        string principle;   // Reliability, Dependability
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => ReliabilityRule) public treaties;
    event ReliabilityRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareReliabilityRule(string calldata principle, string calldata description) external onlyOverseer {
        treatyCount++;
        treaties[treatyCount] = ReliabilityRule(treatyCount, principle, description, block.timestamp);
        emit ReliabilityRuleDeclared(treatyCount, principle, description);
    }
}

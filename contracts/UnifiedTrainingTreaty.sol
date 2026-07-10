pragma solidity ^0.8.20;

contract UnifiedTrainingTreaty {
    address public overseer;
    uint256 public treatyCount;

    struct TrainingRule {
        uint256 id;
        string principle;   // Unified Training, Three Dimensions
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => TrainingRule) public treaties;
    event TrainingRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareTrainingRule(string calldata principle, string calldata description) external onlyOverseer {
        treatyCount++;
        treaties[treatyCount] = TrainingRule(treatyCount, principle, description, block.timestamp);
        emit TrainingRuleDeclared(treatyCount, principle, description);
    }
}

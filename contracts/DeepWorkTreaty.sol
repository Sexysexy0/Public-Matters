pragma solidity ^0.8.20;

contract DeepWorkTreaty {
    address public overseer;
    uint256 public treatyCount;

    struct DeepWorkRule {
        uint256 id;
        string principle;   // Immersion, Productivity, Mastery
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => DeepWorkRule) public treaties;
    event DeepWorkRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareDeepWorkRule(string calldata principle, string calldata description) external onlyOverseer {
        treatyCount++;
        treaties[treatyCount] = DeepWorkRule(treatyCount, principle, description, block.timestamp);
        emit DeepWorkRuleDeclared(treatyCount, principle, description);
    }
}

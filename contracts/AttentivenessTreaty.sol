pragma solidity ^0.8.20;

contract AttentivenessTreaty {
    address public overseer;
    uint256 public treatyCount;

    struct AttentivenessRule {
        uint256 id;
        string principle;   // Focus, Care, Mindful Observation
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => AttentivenessRule) public treaties;
    event AttentivenessRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareAttentivenessRule(string calldata principle, string calldata description) external onlyOverseer {
        treatyCount++;
        treaties[treatyCount] = AttentivenessRule(treatyCount, principle, description, block.timestamp);
        emit AttentivenessRuleDeclared(treatyCount, principle, description);
    }
}

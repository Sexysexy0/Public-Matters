pragma solidity ^0.8.20;

contract StabilityTreaty {
    address public overseer;
    uint256 public treatyCount;

    struct StabilityRule {
        uint256 id;
        string principle;   // Stability, Resilience, Order
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => StabilityRule) public treaties;
    event StabilityRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareStabilityRule(string calldata principle, string calldata description) external onlyOverseer {
        treatyCount++;
        treaties[treatyCount] = StabilityRule(treatyCount, principle, description, block.timestamp);
        emit StabilityRuleDeclared(treatyCount, principle, description);
    }
}

pragma solidity ^0.8.20;

contract ContinuousOutputTreaty {
    address public overseer;
    uint256 public treatyCount;

    struct OutputRule {
        uint256 id;
        string principle;   // Continuous Output, Steady Releases
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => OutputRule) public treaties;
    event OutputRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareOutputRule(string calldata principle, string calldata description) external onlyOverseer {
        treatyCount++;
        treaties[treatyCount] = OutputRule(treatyCount, principle, description, block.timestamp);
        emit OutputRuleDeclared(treatyCount, principle, description);
    }
}

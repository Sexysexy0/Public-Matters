pragma solidity ^0.8.20;

contract DebateTreaty {
    address public overseer;
    uint256 public treatyCount;

    struct DebateRule {
        uint256 id;
        string principle;   // Dialogue, Argumentation, Truth-Testing
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => DebateRule) public treaties;
    event DebateRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareDebateRule(string calldata principle, string calldata description) external onlyOverseer {
        treatyCount++;
        treaties[treatyCount] = DebateRule(treatyCount, principle, description, block.timestamp);
        emit DebateRuleDeclared(treatyCount, principle, description);
    }
}

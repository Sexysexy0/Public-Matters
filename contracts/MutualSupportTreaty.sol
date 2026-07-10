pragma solidity ^0.8.20;

contract MutualSupportTreaty {
    address public overseer;
    uint256 public treatyCount;

    struct SupportRule {
        uint256 id;
        string principle;   // Mutual Support, Reciprocal Aid
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => SupportRule) public treaties;
    event SupportRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareSupportRule(string calldata principle, string calldata description) external onlyOverseer {
        treatyCount++;
        treaties[treatyCount] = SupportRule(treatyCount, principle, description, block.timestamp);
        emit SupportRuleDeclared(treatyCount, principle, description);
    }
}

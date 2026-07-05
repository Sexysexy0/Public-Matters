pragma solidity ^0.8.20;

contract GivingTreaty {
    address public overseer;
    uint256 public treatyCount;

    struct GivingRule {
        uint256 id;
        string principle;   // Giving, Altruism, Collective Uplift
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => GivingRule) public treaties;
    event GivingRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareGivingRule(string calldata principle, string calldata description) external onlyOverseer {
        treatyCount++;
        treaties[treatyCount] = GivingRule(treatyCount, principle, description, block.timestamp);
        emit GivingRuleDeclared(treatyCount, principle, description);
    }
}

pragma solidity ^0.8.20;

contract GoodwillTreaty {
    address public overseer;
    uint256 public treatyCount;

    struct GoodwillRule {
        uint256 id;
        string principle;   // Goodwill, Benevolence
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => GoodwillRule) public treaties;
    event GoodwillRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareGoodwillRule(string calldata principle, string calldata description) external onlyOverseer {
        treatyCount++;
        treaties[treatyCount] = GoodwillRule(treatyCount, principle, description, block.timestamp);
        emit GoodwillRuleDeclared(treatyCount, principle, description);
    }
}

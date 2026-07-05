pragma solidity ^0.8.20;

contract ExchangeScroll {
    address public overseer;
    uint256 public scrollCount;

    struct ExchangeRule {
        uint256 id;
        string principle;   // Sharing, Collaboration, Growth
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => ExchangeRule) public rules;
    event ExchangeRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareExchangeRule(string calldata principle, string calldata description) external onlyOverseer {
        scrollCount++;
        rules[scrollCount] = ExchangeRule(scrollCount, principle, description, block.timestamp);
        emit ExchangeRuleDeclared(scrollCount, principle, description);
    }
}

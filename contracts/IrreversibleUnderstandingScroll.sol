pragma solidity ^0.8.20;

contract IrreversibleUnderstandingScroll {
    address public overseer;
    uint256 public scrollCount;

    struct UnderstandingRule {
        uint256 id;
        string principle;   // Irreversible Understanding, No Return
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => UnderstandingRule) public rules;
    event UnderstandingRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareUnderstandingRule(string calldata principle, string calldata description) external onlyOverseer {
        scrollCount++;
        rules[scrollCount] = UnderstandingRule(scrollCount, principle, description, block.timestamp);
        emit UnderstandingRuleDeclared(scrollCount, principle, description);
    }
}

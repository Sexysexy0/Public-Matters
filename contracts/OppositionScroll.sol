pragma solidity ^0.8.20;

contract OppositionScroll {
    address public overseer;
    uint256 public scrollCount;

    struct OppositionRule {
        uint256 id;
        string principle;   // Dissent, Balance, Resilience
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => OppositionRule) public rules;
    event OppositionRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareOppositionRule(string calldata principle, string calldata description) external onlyOverseer {
        scrollCount++;
        rules[scrollCount] = OppositionRule(scrollCount, principle, description, block.timestamp);
        emit OppositionRuleDeclared(scrollCount, principle, description);
    }
}

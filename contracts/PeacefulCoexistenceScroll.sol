pragma solidity ^0.8.20;

contract PeacefulCoexistenceScroll {
    address public overseer;
    uint256 public scrollCount;

    struct CoexistenceRule {
        uint256 id;
        string principle;   // Peaceful Coexistence, Mutual Respect
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => CoexistenceRule) public rules;
    event CoexistenceRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareCoexistenceRule(string calldata principle, string calldata description) external onlyOverseer {
        scrollCount++;
        rules[scrollCount] = CoexistenceRule(scrollCount, principle, description, block.timestamp);
        emit CoexistenceRuleDeclared(scrollCount, principle, description);
    }
}

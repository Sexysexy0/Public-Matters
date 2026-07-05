pragma solidity ^0.8.20;

contract ReliefScroll {
    address public overseer;
    uint256 public scrollCount;

    struct ReliefRule {
        uint256 id;
        string principle;   // Relief, Setting Down Weight
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => ReliefRule) public rules;
    event ReliefRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareReliefRule(string calldata principle, string calldata description) external onlyOverseer {
        scrollCount++;
        rules[scrollCount] = ReliefRule(scrollCount, principle, description, block.timestamp);
        emit ReliefRuleDeclared(scrollCount, principle, description);
    }
}

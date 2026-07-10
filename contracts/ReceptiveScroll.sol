pragma solidity ^0.8.20;

contract ReceptiveScroll {
    address public overseer;
    uint256 public scrollCount;

    struct ReceptiveRule {
        uint256 id;
        string principle;   // Openness, Responsiveness, Balanced Intake
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => ReceptiveRule) public rules;
    event ReceptiveRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareReceptiveRule(string calldata principle, string calldata description) external onlyOverseer {
        scrollCount++;
        rules[scrollCount] = ReceptiveRule(scrollCount, principle, description, block.timestamp);
        emit ReceptiveRuleDeclared(scrollCount, principle, description);
    }
}

pragma solidity ^0.8.20;

contract BenevolenceScroll {
    address public overseer;
    uint256 public scrollCount;

    struct BenevolenceRule {
        uint256 id;
        string principle;   // Benevolence, Goodwill
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => BenevolenceRule) public rules;
    event BenevolenceRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareBenevolenceRule(string calldata principle, string calldata description) external onlyOverseer {
        scrollCount++;
        rules[scrollCount] = BenevolenceRule(scrollCount, principle, description, block.timestamp);
        emit BenevolenceRuleDeclared(scrollCount, principle, description);
    }
}

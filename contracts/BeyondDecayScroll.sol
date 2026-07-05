pragma solidity ^0.8.20;

contract BeyondDecayScroll {
    address public overseer;
    uint256 public scrollCount;

    struct DecayRule {
        uint256 id;
        string principle;   // Beyond Decay, Eternal Resilience
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => DecayRule) public rules;
    event DecayRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareDecayRule(string calldata principle, string calldata description) external onlyOverseer {
        scrollCount++;
        rules[scrollCount] = DecayRule(scrollCount, principle, description, block.timestamp);
        emit DecayRuleDeclared(scrollCount, principle, description);
    }
}

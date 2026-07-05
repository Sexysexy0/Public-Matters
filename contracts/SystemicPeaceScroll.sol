pragma solidity ^0.8.20;

contract SystemicPeaceScroll {
    address public overseer;
    uint256 public scrollCount;

    struct PeaceRule {
        uint256 id;
        string principle;   // Systemic Peace, Resonant Unity
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => PeaceRule) public rules;
    event PeaceRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declarePeaceRule(string calldata principle, string calldata description) external onlyOverseer {
        scrollCount++;
        rules[scrollCount] = PeaceRule(scrollCount, principle, description, block.timestamp);
        emit PeaceRuleDeclared(scrollCount, principle, description);
    }
}

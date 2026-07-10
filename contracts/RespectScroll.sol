pragma solidity ^0.8.20;

contract RespectScroll {
    address public overseer;
    uint256 public scrollCount;

    struct RespectRule {
        uint256 id;
        string principle;   // Respect, Dignity, Listening
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => RespectRule) public rules;
    event RespectRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareRespectRule(string calldata principle, string calldata description) external onlyOverseer {
        scrollCount++;
        rules[scrollCount] = RespectRule(scrollCount, principle, description, block.timestamp);
        emit RespectRuleDeclared(scrollCount, principle, description);
    }
}

pragma solidity ^0.8.20;

contract DestinyScroll {
    address public overseer;
    uint256 public scrollCount;

    struct DestinyRule {
        uint256 id;
        string principle;   // Destiny, Leadership, Responsibility
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => DestinyRule) public rules;
    event DestinyRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareDestinyRule(string calldata principle, string calldata description) external onlyOverseer {
        scrollCount++;
        rules[scrollCount] = DestinyRule(scrollCount, principle, description, block.timestamp);
        emit DestinyRuleDeclared(scrollCount, principle, description);
    }
}

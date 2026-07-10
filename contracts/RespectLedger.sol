pragma solidity ^0.8.20;

contract RespectLedger {
    address public overseer;
    uint256 public entryCount;

    struct RespectRule {
        uint256 id;
        string principle;   // Dignity, Fairness, Courtesy
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => RespectRule) public entries;
    event RespectRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareRespectRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = RespectRule(entryCount, principle, description, block.timestamp);
        emit RespectRuleDeclared(entryCount, principle, description);
    }
}

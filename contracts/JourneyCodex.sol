pragma solidity ^0.8.20;

contract JourneyCodex {
    address public overseer;
    uint256 public codexCount;

    struct JourneyRule {
        uint256 id;
        string principle;   // Adventure, Discovery, Travel
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => JourneyRule) public rules;
    event JourneyRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareJourneyRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = JourneyRule(codexCount, principle, description, block.timestamp);
        emit JourneyRuleDeclared(codexCount, principle, description);
    }
}

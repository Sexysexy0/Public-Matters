pragma solidity ^0.8.20;

contract CharacterResonanceLedger {
    address public overseer;
    uint256 public entryCount;

    struct CharacterRule {
        uint256 id;
        string principle;   // Character Resonance, Identity Arc
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => CharacterRule) public entries;
    event CharacterRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareCharacterRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = CharacterRule(entryCount, principle, description, block.timestamp);
        emit CharacterRuleDeclared(entryCount, principle, description);
    }
}

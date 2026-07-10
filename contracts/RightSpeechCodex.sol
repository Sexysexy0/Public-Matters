pragma solidity ^0.8.20;

contract RightSpeechCodex {
    address public overseer;
    uint256 public codexCount;

    struct SpeechRule {
        uint256 id;
        string principle;   // Right Speech, Loosen Tangle
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => SpeechRule) public rules;
    event SpeechRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareSpeechRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = SpeechRule(codexCount, principle, description, block.timestamp);
        emit SpeechRuleDeclared(codexCount, principle, description);
    }
}

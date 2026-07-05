pragma solidity ^0.8.20;

contract SpeechRegulationTreaty {
    address public overseer;
    uint256 public treatyCount;

    struct SpeechRule {
        uint256 id;
        string principle;   // Speech Regulation, Democratic Safeguards
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => SpeechRule) public treaties;
    event SpeechRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareSpeechRule(string calldata principle, string calldata description) external onlyOverseer {
        treatyCount++;
        treaties[treatyCount] = SpeechRule(treatyCount, principle, description, block.timestamp);
        emit SpeechRuleDeclared(treatyCount, principle, description);
    }
}

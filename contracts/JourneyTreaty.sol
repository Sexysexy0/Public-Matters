pragma solidity ^0.8.20;

contract JourneyTreaty {
    address public overseer;
    uint256 public treatyCount;

    struct JourneyRule {
        uint256 id;
        string principle;   // Purposeful Travel, Discovery, Adventure
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => JourneyRule) public treaties;
    event JourneyRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareJourneyRule(string calldata principle, string calldata description) external onlyOverseer {
        treatyCount++;
        treaties[treatyCount] = JourneyRule(treatyCount, principle, description, block.timestamp);
        emit JourneyRuleDeclared(treatyCount, principle, description);
    }
}

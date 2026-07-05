pragma solidity ^0.8.20;

contract DirectParticipationLedger {
    address public overseer;
    uint256 public entryCount;

    struct ParticipationRule {
        uint256 id;
        string principle;   // Direct Participation, Plebiscite, Initiative
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => ParticipationRule) public entries;
    event ParticipationRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareParticipationRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = ParticipationRule(entryCount, principle, description, block.timestamp);
        emit ParticipationRuleDeclared(entryCount, principle, description);
    }
}

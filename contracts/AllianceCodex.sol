pragma solidity ^0.8.20;

contract AllianceCodex {
    address public overseer;
    uint256 public codexCount;

    struct AllianceRule {
        uint256 id;
        string principle;   // Alliance, Partnership, Solidarity
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => AllianceRule) public rules;
    event AllianceRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareAllianceRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = AllianceRule(codexCount, principle, description, block.timestamp);
        emit AllianceRuleDeclared(codexCount, principle, description);
    }
}

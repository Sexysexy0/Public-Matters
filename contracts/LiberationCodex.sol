pragma solidity ^0.8.20;

contract LiberationCodex {
    address public overseer;
    uint256 public codexCount;

    struct LiberationRule {
        uint256 id;
        string principle;   // Liberation, End of Path
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => LiberationRule) public rules;
    event LiberationRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareLiberationRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = LiberationRule(codexCount, principle, description, block.timestamp);
        emit LiberationRuleDeclared(codexCount, principle, description);
    }
}

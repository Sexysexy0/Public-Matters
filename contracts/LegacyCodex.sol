pragma solidity ^0.8.20;

contract LegacyCodex {
    address public overseer;
    uint256 public codexCount;

    struct LegacyRule {
        uint256 id;
        string principle;   // Legacy, Inheritance, Lineage
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => LegacyRule) public rules;
    event LegacyRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareLegacyRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = LegacyRule(codexCount, principle, description, block.timestamp);
        emit LegacyRuleDeclared(codexCount, principle, description);
    }
}

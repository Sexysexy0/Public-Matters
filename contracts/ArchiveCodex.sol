pragma solidity ^0.8.20;

contract ArchiveCodex {
    address public overseer;
    uint256 public codexCount;

    struct ArchiveRule {
        uint256 id;
        string principle;   // Archive, Preservation, Memory
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => ArchiveRule) public rules;
    event ArchiveRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareArchiveRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = ArchiveRule(codexCount, principle, description, block.timestamp);
        emit ArchiveRuleDeclared(codexCount, principle, description);
    }
}

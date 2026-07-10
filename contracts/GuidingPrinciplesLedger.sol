pragma solidity ^0.8.20;

contract GuidingPrinciplesLedger {
    address public overseer;
    uint256 public entryCount;

    struct PrincipleRule {
        uint256 id;
        string principle;   // Guiding Principles, Ethical Anchors
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => PrincipleRule) public entries;
    event PrincipleRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declarePrincipleRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = PrincipleRule(entryCount, principle, description, block.timestamp);
        emit PrincipleRuleDeclared(entryCount, principle, description);
    }
}

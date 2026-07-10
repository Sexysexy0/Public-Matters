pragma solidity ^0.8.20;

contract ArgumentLedger {
    address public overseer;
    uint256 public entryCount;

    struct ArgumentRule {
        uint256 id;
        string principle;   // Reasoning, Persuasion, Logic
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => ArgumentRule) public entries;
    event ArgumentRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareArgumentRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = ArgumentRule(entryCount, principle, description, block.timestamp);
        emit ArgumentRuleDeclared(entryCount, principle, description);
    }
}

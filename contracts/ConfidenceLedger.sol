pragma solidity ^0.8.20;

contract ConfidenceLedger {
    address public overseer;
    uint256 public entryCount;

    struct ConfidenceRule {
        uint256 id;
        string principle;   // Confidence, Assurance, Stability
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => ConfidenceRule) public entries;
    event ConfidenceRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareConfidenceRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = ConfidenceRule(entryCount, principle, description, block.timestamp);
        emit ConfidenceRuleDeclared(entryCount, principle, description);
    }
}

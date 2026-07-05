pragma solidity ^0.8.20;

contract EnvironmentalDetailLedger {
    address public overseer;
    uint256 public entryCount;

    struct DetailRule {
        uint256 id;
        string principle;   // Environmental Detail, Contextual Immersion
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => DetailRule) public entries;
    event DetailRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareDetailRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = DetailRule(entryCount, principle, description, block.timestamp);
        emit DetailRuleDeclared(entryCount, principle, description);
    }
}

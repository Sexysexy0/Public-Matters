pragma solidity ^0.8.20;

contract InvestigationLedger {
    address public overseer;
    uint256 public entryCount;

    struct InvestigationRule {
        uint256 id;
        string principle;   // Research, Evidence, Inquiry
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => InvestigationRule) public entries;
    event InvestigationRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareInvestigationRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = InvestigationRule(entryCount, principle, description, block.timestamp);
        emit InvestigationRuleDeclared(entryCount, principle, description);
    }
}

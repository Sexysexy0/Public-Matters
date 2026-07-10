pragma solidity ^0.8.20;

contract CareLedger {
    address public overseer;
    uint256 public entryCount;

    struct CareRule {
        uint256 id;
        string principle;   // Compassion, Diligence, Responsibility
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => CareRule) public entries;
    event CareRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareCareRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = CareRule(entryCount, principle, description, block.timestamp);
        emit CareRuleDeclared(entryCount, principle, description);
    }
}

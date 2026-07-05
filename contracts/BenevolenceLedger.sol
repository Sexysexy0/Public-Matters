pragma solidity ^0.8.20;

contract BenevolenceLedger {
    address public overseer;
    uint256 public entryCount;

    struct BenevolenceRule {
        uint256 id;
        string principle;   // Benevolence, Compassion
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => BenevolenceRule) public entries;
    event BenevolenceRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareBenevolenceRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = BenevolenceRule(entryCount, principle, description, block.timestamp);
        emit BenevolenceRuleDeclared(entryCount, principle, description);
    }
}

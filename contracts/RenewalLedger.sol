pragma solidity ^0.8.20;

contract RenewalLedger {
    address public overseer;
    uint256 public entryCount;

    struct RenewalRule {
        uint256 id;
        string principle;   // Renewal, Rebirth, Regeneration
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => RenewalRule) public entries;
    event RenewalRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareRenewalRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = RenewalRule(entryCount, principle, description, block.timestamp);
        emit RenewalRuleDeclared(entryCount, principle, description);
    }
}

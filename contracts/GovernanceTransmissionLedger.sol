pragma solidity ^0.8.20;

contract GovernanceTransmissionLedger {
    address public overseer;
    uint256 public entryCount;

    struct TransmissionRule {
        uint256 id;
        string principle;   // Governance Transmission, Continuity
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => TransmissionRule) public entries;
    event TransmissionRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareTransmissionRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = TransmissionRule(entryCount, principle, description, block.timestamp);
        emit TransmissionRuleDeclared(entryCount, principle, description);
    }
}

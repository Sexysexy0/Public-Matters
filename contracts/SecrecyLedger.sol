pragma solidity ^0.8.20;

contract SecrecyLedger {
    address public overseer;
    uint256 public entryCount;

    struct SecrecyRule {
        uint256 id;
        string principle;   // Secrecy of Ballot
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => SecrecyRule) public entries;
    event SecrecyRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareSecrecyRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = SecrecyRule(entryCount, principle, description, block.timestamp);
        emit SecrecyRuleDeclared(entryCount, principle, description);
    }
}

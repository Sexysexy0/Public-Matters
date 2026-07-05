pragma solidity ^0.8.20;

contract NeoliberalReformsLedger {
    address public overseer;
    uint256 public entryCount;

    struct ReformRule {
        uint256 id;
        string principle;   // Neoliberal Reforms, Economic Policy
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => ReformRule) public entries;
    event ReformRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareReformRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = ReformRule(entryCount, principle, description, block.timestamp);
        emit ReformRuleDeclared(entryCount, principle, description);
    }
}

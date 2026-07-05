pragma solidity ^0.8.20;

contract ResolveLedger {
    address public overseer;
    uint256 public entryCount;

    struct ResolveRule {
        uint256 id;
        string principle;   // Resolve, Determination, Commitment
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => ResolveRule) public entries;
    event ResolveRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareResolveRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = ResolveRule(entryCount, principle, description, block.timestamp);
        emit ResolveRuleDeclared(entryCount, principle, description);
    }
}

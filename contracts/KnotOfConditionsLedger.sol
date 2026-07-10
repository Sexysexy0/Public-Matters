pragma solidity ^0.8.20;

contract KnotOfConditionsLedger {
    address public overseer;
    uint256 public entryCount;

    struct KnotRule {
        uint256 id;
        string principle;   // Knot of Conditions, Snarl
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => KnotRule) public entries;
    event KnotRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareKnotRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = KnotRule(entryCount, principle, description, block.timestamp);
        emit KnotRuleDeclared(entryCount, principle, description);
    }
}

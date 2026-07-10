pragma solidity ^0.8.20;

contract AutomaticSeeingLedger {
    address public overseer;
    uint256 public entryCount;

    struct SeeingRule {
        uint256 id;
        string principle;   // Automatic Seeing, Literacy of Reality
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => SeeingRule) public entries;
    event SeeingRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareSeeingRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = SeeingRule(entryCount, principle, description, block.timestamp);
        emit SeeingRuleDeclared(entryCount, principle, description);
    }
}

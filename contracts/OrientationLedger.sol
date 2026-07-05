pragma solidity ^0.8.20;

contract OrientationLedger {
    address public overseer;
    uint256 public entryCount;

    struct OrientationRule {
        uint256 id;
        string principle;   // Direction, Alignment, Focus
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => OrientationRule) public entries;
    event OrientationRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareOrientationRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = OrientationRule(entryCount, principle, description, block.timestamp);
        emit OrientationRuleDeclared(entryCount, principle, description);
    }
}

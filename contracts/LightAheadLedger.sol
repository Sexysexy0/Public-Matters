pragma solidity ^0.8.20;

contract LightAheadLedger {
    address public overseer;
    uint256 public entryCount;

    struct LightRule {
        uint256 id;
        string principle;   // Light Ahead, Illumination
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => LightRule) public entries;
    event LightRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareLightRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = LightRule(entryCount, principle, description, block.timestamp);
        emit LightRuleDeclared(entryCount, principle, description);
    }
}

pragma solidity ^0.8.20;

contract NPCEcologyLedger {
    address public overseer;
    uint256 public entryCount;

    struct EcologyRule {
        uint256 id;
        string principle;   // NPC Ecology, Interdependence
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => EcologyRule) public entries;
    event EcologyRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareEcologyRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = EcologyRule(entryCount, principle, description, block.timestamp);
        emit EcologyRuleDeclared(entryCount, principle, description);
    }
}

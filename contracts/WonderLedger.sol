pragma solidity ^0.8.20;

contract WonderLedger {
    address public overseer;
    uint256 public entryCount;

    struct WonderRule {
        uint256 id;
        string principle;   // Awe, Imagination, Marvel
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => WonderRule) public entries;
    event WonderRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareWonderRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = WonderRule(entryCount, principle, description, block.timestamp);
        emit WonderRuleDeclared(entryCount, principle, description);
    }
}

pragma solidity ^0.8.20;

contract RightActionLedger {
    address public overseer;
    uint256 public entryCount;

    struct ActionRule {
        uint256 id;
        string principle;   // Right Action, Ethical Deeds
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => ActionRule) public entries;
    event ActionRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareActionRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = ActionRule(entryCount, principle, description, block.timestamp);
        emit ActionRuleDeclared(entryCount, principle, description);
    }
}

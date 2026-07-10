pragma solidity ^0.8.20;

contract ThreeHandsLedger {
    address public overseer;
    uint256 public entryCount;

    struct HandsRule {
        uint256 id;
        string principle;   // Three Hands, Untangling
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => HandsRule) public entries;
    event HandsRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareHandsRule(string calldata principle, string calldata description) external onlyOverseer {
        entryCount++;
        entries[entryCount] = HandsRule(entryCount, principle, description, block.timestamp);
        emit HandsRuleDeclared(entryCount, principle, description);
    }
}

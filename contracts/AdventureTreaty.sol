pragma solidity ^0.8.20;

contract AdventureTreaty {
    address public overseer;
    uint256 public treatyCount;

    struct AdventureRule {
        uint256 id;
        string principle;   // Courage, Exploration, Risk-Taking
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => AdventureRule) public treaties;
    event AdventureRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareAdventureRule(string calldata principle, string calldata description) external onlyOverseer {
        treatyCount++;
        treaties[treatyCount] = AdventureRule(treatyCount, principle, description, block.timestamp);
        emit AdventureRuleDeclared(treatyCount, principle, description);
    }
}

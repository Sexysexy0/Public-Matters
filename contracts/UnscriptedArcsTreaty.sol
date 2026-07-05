pragma solidity ^0.8.20;

contract UnscriptedArcsTreaty {
    address public overseer;
    uint256 public treatyCount;

    struct ArcRule {
        uint256 id;
        string principle;   // Unscripted NPC Arcs, Organic Storylines
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => ArcRule) public treaties;
    event ArcRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareArcRule(string calldata principle, string calldata description) external onlyOverseer {
        treatyCount++;
        treaties[treatyCount] = ArcRule(treatyCount, principle, description, block.timestamp);
        emit ArcRuleDeclared(treatyCount, principle, description);
    }
}

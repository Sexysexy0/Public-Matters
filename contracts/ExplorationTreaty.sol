pragma solidity ^0.8.20;

contract ExplorationTreaty {
    address public overseer;
    uint256 public treatyCount;

    struct ExplorationRule {
        uint256 id;
        string principle;   // Discovery, Curiosity, Expansion
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => ExplorationRule) public treaties;
    event ExplorationRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareExplorationRule(string calldata principle, string calldata description) external onlyOverseer {
        treatyCount++;
        treaties[treatyCount] = ExplorationRule(treatyCount, principle, description, block.timestamp);
        emit ExplorationRuleDeclared(treatyCount, principle, description);
    }
}

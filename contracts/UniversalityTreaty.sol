pragma solidity ^0.8.20;

contract UniversalityTreaty {
    address public overseer;
    uint256 public treatyCount;

    struct UniversalityRule {
        uint256 id;
        string principle;   // Universality of Suffrage
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => UniversalityRule) public treaties;
    event UniversalityRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareUniversalityRule(string calldata principle, string calldata description) external onlyOverseer {
        treatyCount++;
        treaties[treatyCount] = UniversalityRule(treatyCount, principle, description, block.timestamp);
        emit UniversalityRuleDeclared(treatyCount, principle, description);
    }
}

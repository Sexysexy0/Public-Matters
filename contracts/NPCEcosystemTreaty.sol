pragma solidity ^0.8.20;

contract NPCEcosystemTreaty {
    address public overseer;
    uint256 public treatyCount;

    struct EcosystemRule {
        uint256 id;
        string principle;   // NPC Ecosystem, Interdependence
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => EcosystemRule) public treaties;
    event EcosystemRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareEcosystemRule(string calldata principle, string calldata description) external onlyOverseer {
        treatyCount++;
        treaties[treatyCount] = EcosystemRule(treatyCount, principle, description, block.timestamp);
        emit EcosystemRuleDeclared(treatyCount, principle, description);
    }
}

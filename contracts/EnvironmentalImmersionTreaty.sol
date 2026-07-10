pragma solidity ^0.8.20;

contract EnvironmentalImmersionTreaty {
    address public overseer;
    uint256 public treatyCount;

    struct ImmersionRule {
        uint256 id;
        string principle;   // Environmental Immersion, Contextual Detail
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => ImmersionRule) public treaties;
    event ImmersionRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareImmersionRule(string calldata principle, string calldata description) external onlyOverseer {
        treatyCount++;
        treaties[treatyCount] = ImmersionRule(treatyCount, principle, description, block.timestamp);
        emit ImmersionRuleDeclared(treatyCount, principle, description);
    }
}

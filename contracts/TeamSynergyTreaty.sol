pragma solidity ^0.8.20;

contract TeamSynergyTreaty {
    address public overseer;
    uint256 public treatyCount;

    struct SynergyRule {
        uint256 id;
        string principle;   // Team Synergy, Collaboration
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => SynergyRule) public treaties;
    event SynergyRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareSynergyRule(string calldata principle, string calldata description) external onlyOverseer {
        treatyCount++;
        treaties[treatyCount] = SynergyRule(treatyCount, principle, description, block.timestamp);
        emit SynergyRuleDeclared(treatyCount, principle, description);
    }
}

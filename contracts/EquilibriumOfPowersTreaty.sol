pragma solidity ^0.8.20;

contract EquilibriumOfPowersTreaty {
    address public overseer;
    uint256 public treatyCount;

    struct PowerRule {
        uint256 id;
        string principle;   // Equilibrium of Powers
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => PowerRule) public treaties;
    event PowerRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declarePowerRule(string calldata principle, string calldata description) external onlyOverseer {
        treatyCount++;
        treaties[treatyCount] = PowerRule(treatyCount, principle, description, block.timestamp);
        emit PowerRuleDeclared(treatyCount, principle, description);
    }
}

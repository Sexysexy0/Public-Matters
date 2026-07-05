pragma solidity ^0.8.20;

contract EcoVentilationTreaty {
    address public overseer;
    uint256 public treatyCount;

    struct VentRule {
        uint256 id;
        string principle;   // Passive Ventilation, Cooling, Fairness
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => VentRule) public treaties;
    event VentRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareVentRule(string calldata principle, string calldata description) external onlyOverseer {
        treatyCount++;
        treaties[treatyCount] = VentRule(treatyCount, principle, description, block.timestamp);
        emit VentRuleDeclared(treatyCount, principle, description);
    }
}

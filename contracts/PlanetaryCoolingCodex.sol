pragma solidity ^0.8.20;

/// @title PlanetaryCoolingCodex
/// @notice Covenant for global passive cooling strategies.
/// @dev Anchors tree belts, reflective surfaces, ventilation, and fairness.

contract PlanetaryCoolingCodex {
    address public overseer;
    uint256 public codexCount;

    struct CoolingRule {
        uint256 id;
        string principle;   // Global Cooling, Passive Systems, Equity
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => CoolingRule) public rules;
    event CoolingRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareCoolingRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = CoolingRule(codexCount, principle, description, block.timestamp);
        emit CoolingRuleDeclared(codexCount, principle, description);
    }
}

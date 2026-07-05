pragma solidity ^0.8.20;

contract HarmonyCodex {
    address public overseer;
    uint256 public codexCount;

    struct HarmonyRule {
        uint256 id;
        string principle;   // Harmony, Balance, Coexistence
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => HarmonyRule) public rules;
    event HarmonyRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareHarmonyRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = HarmonyRule(codexCount, principle, description, block.timestamp);
        emit HarmonyRuleDeclared(codexCount, principle, description);
    }
}

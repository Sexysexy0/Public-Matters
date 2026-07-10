pragma solidity ^0.8.20;

contract ConvergenceCodex {
    address public overseer;
    uint256 public codexCount;

    struct ConvergenceRule {
        uint256 id;
        string principle;   // Convergence, Unified Destiny, Fusion
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => ConvergenceRule) public rules;
    event ConvergenceRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareConvergenceRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = ConvergenceRule(codexCount, principle, description, block.timestamp);
        emit ConvergenceRuleDeclared(codexCount, principle, description);
    }
}

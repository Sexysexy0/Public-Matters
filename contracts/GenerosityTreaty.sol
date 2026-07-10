pragma solidity ^0.8.20;

contract GenerosityTreaty {
    address public overseer;
    uint256 public treatyCount;

    struct GenerosityRule {
        uint256 id;
        string principle;   // Generosity, Fair Sharing
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => GenerosityRule) public treaties;
    event GenerosityRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareGenerosityRule(string calldata principle, string calldata description) external onlyOverseer {
        treatyCount++;
        treaties[treatyCount] = GenerosityRule(treatyCount, principle, description, block.timestamp);
        emit GenerosityRuleDeclared(treatyCount, principle, description);
    }
}

pragma solidity ^0.8.20;

contract EnduranceTreaty {
    address public overseer;
    uint256 public treatyCount;

    struct EnduranceRule {
        uint256 id;
        string principle;   // Long-Term Strength, Perseverance
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => EnduranceRule) public treaties;
    event EnduranceRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareEnduranceRule(string calldata principle, string calldata description) external onlyOverseer {
        treatyCount++;
        treaties[treatyCount] = EnduranceRule(treatyCount, principle, description, block.timestamp);
        emit EnduranceRuleDeclared(treatyCount, principle, description);
    }
}

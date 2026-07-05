pragma solidity ^0.8.20;

contract RightConcentrationTreaty {
    address public overseer;
    uint256 public treatyCount;

    struct ConcentrationRule {
        uint256 id;
        string principle;   // Right Concentration, Collected Mind
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => ConcentrationRule) public treaties;
    event ConcentrationRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareConcentrationRule(string calldata principle, string calldata description) external onlyOverseer {
        treatyCount++;
        treaties[treatyCount] = ConcentrationRule(treatyCount, principle, description, block.timestamp);
        emit ConcentrationRuleDeclared(treatyCount, principle, description);
    }
}

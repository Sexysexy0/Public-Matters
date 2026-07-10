pragma solidity ^0.8.20;

contract DependentOriginationTreaty {
    address public overseer;
    uint256 public treatyCount;

    struct OriginationRule {
        uint256 id;
        string principle;   // Dependent Origination, Cause Chain
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => OriginationRule) public treaties;
    event OriginationRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareOriginationRule(string calldata principle, string calldata description) external onlyOverseer {
        treatyCount++;
        treaties[treatyCount] = OriginationRule(treatyCount, principle, description, block.timestamp);
        emit OriginationRuleDeclared(treatyCount, principle, description);
    }
}

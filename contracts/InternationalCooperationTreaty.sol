pragma solidity ^0.8.20;

contract InternationalCooperationTreaty {
    address public overseer;
    uint256 public treatyCount;

    struct CooperationRule {
        uint256 id;
        string principle;   // International Cooperation, Peace, Security
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => CooperationRule) public treaties;
    event CooperationRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareCooperationRule(string calldata principle, string calldata description) external onlyOverseer {
        treatyCount++;
        treaties[treatyCount] = CooperationRule(treatyCount, principle, description, block.timestamp);
        emit CooperationRuleDeclared(treatyCount, principle, description);
    }
}

pragma solidity ^0.8.20;

contract AuthenticityTreaty {
    address public overseer;
    uint256 public treatyCount;

    struct AuthenticityRule {
        uint256 id;
        string principle;   // Faithful Adaptation, Original Narrative
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => AuthenticityRule) public treaties;
    event AuthenticityRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareAuthenticityRule(string calldata principle, string calldata description) external onlyOverseer {
        treatyCount++;
        treaties[treatyCount] = AuthenticityRule(treatyCount, principle, description, block.timestamp);
        emit AuthenticityRuleDeclared(treatyCount, principle, description);
    }
}

pragma solidity ^0.8.20;

contract WholenessCodex {
    address public overseer;
    uint256 public codexCount;

    struct WholenessRule {
        uint256 id;
        string principle;   // Integration, Unity, Balance
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => WholenessRule) public rules;
    event WholenessRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareWholenessRule(string calldata principle, string calldata description) external onlyOverseer {
        codexCount++;
        rules[codexCount] = WholenessRule(codexCount, principle, description, block.timestamp);
        emit WholenessRuleDeclared(codexCount, principle, description);
    }
}

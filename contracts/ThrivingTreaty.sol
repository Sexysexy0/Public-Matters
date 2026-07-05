pragma solidity ^0.8.20;

contract ThrivingTreaty {
    address public overseer;
    uint256 public treatyCount;

    struct ThrivingRule {
        uint256 id;
        string principle;   // Thriving, Growth, Prosperity
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => ThrivingRule) public treaties;
    event ThrivingRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareThrivingRule(string calldata principle, string calldata description) external onlyOverseer {
        treatyCount++;
        treaties[treatyCount] = ThrivingRule(treatyCount, principle, description, block.timestamp);
        emit ThrivingRuleDeclared(treatyCount, principle, description);
    }
}

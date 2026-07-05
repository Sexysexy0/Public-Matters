pragma solidity ^0.8.20;

contract WholenessTreaty {
    address public overseer;
    uint256 public treatyCount;

    struct WholenessRule {
        uint256 id;
        string principle;   // Integration, Balance, Unity
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => WholenessRule) public treaties;
    event WholenessRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareWholenessRule(string calldata principle, string calldata description) external onlyOverseer {
        treatyCount++;
        treaties[treatyCount] = WholenessRule(treatyCount, principle, description, block.timestamp);
        emit WholenessRuleDeclared(treatyCount, principle, description);
    }
}

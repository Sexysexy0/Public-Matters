pragma solidity ^0.8.20;

contract DataLeakManagementTreaty {
    address public overseer;
    uint256 public treatyCount;

    struct LeakRule {
        uint256 id;
        string principle;   // Data Leak Management, Credential Protection
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => LeakRule) public treaties;
    event LeakRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareLeakRule(string calldata principle, string calldata description) external onlyOverseer {
        treatyCount++;
        treaties[treatyCount] = LeakRule(treatyCount, principle, description, block.timestamp);
        emit LeakRuleDeclared(treatyCount, principle, description);
    }
}

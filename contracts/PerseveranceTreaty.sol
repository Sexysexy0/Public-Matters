pragma solidity ^0.8.20;

contract PerseveranceTreaty {
    address public overseer;
    uint256 public treatyCount;

    struct PerseveranceRule {
        uint256 id;
        string principle;   // Perseverance, Endurance
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => PerseveranceRule) public treaties;
    event PerseveranceRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declarePerseveranceRule(string calldata principle, string calldata description) external onlyOverseer {
        treatyCount++;
        treaties[treatyCount] = PerseveranceRule(treatyCount, principle, description, block.timestamp);
        emit PerseveranceRuleDeclared(treatyCount, principle, description);
    }
}

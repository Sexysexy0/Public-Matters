pragma solidity ^0.8.20;

contract PermanenceTreaty {
    address public overseer;
    uint256 public treatyCount;

    struct PermanenceRule {
        uint256 id;
        string principle;   // Permanence, Continuity
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => PermanenceRule) public treaties;
    event PermanenceRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declarePermanenceRule(string calldata principle, string calldata description) external onlyOverseer {
        treatyCount++;
        treaties[treatyCount] = PermanenceRule(treatyCount, principle, description, block.timestamp);
        emit PermanenceRuleDeclared(treatyCount, principle, description);
    }
}

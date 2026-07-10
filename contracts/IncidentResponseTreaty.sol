pragma solidity ^0.8.20;

contract IncidentResponseTreaty {
    address public overseer;
    uint256 public treatyCount;

    struct ResponseRule {
        uint256 id;
        string principle;   // Incident Response, Detection, Containment
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => ResponseRule) public treaties;
    event ResponseRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareResponseRule(string calldata principle, string calldata description) external onlyOverseer {
        treatyCount++;
        treaties[treatyCount] = ResponseRule(treatyCount, principle, description, block.timestamp);
        emit ResponseRuleDeclared(treatyCount, principle, description);
    }
}

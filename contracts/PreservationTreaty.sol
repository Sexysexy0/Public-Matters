pragma solidity ^0.8.20;

contract PreservationTreaty {
    address public overseer;
    uint256 public treatyCount;

    struct PreservationRule {
        uint256 id;
        string principle;   // Preservation, Safeguarding
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => PreservationRule) public treaties;
    event PreservationRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declarePreservationRule(string calldata principle, string calldata description) external onlyOverseer {
        treatyCount++;
        treaties[treatyCount] = PreservationRule(treatyCount, principle, description, block.timestamp);
        emit PreservationRuleDeclared(treatyCount, principle, description);
    }
}

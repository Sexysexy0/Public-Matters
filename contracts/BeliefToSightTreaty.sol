pragma solidity ^0.8.20;

contract BeliefToSightTreaty {
    address public overseer;
    uint256 public treatyCount;

    struct SightRule {
        uint256 id;
        string principle;   // Belief to Sight, Direct Seeing
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => SightRule) public treaties;
    event SightRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareSightRule(string calldata principle, string calldata description) external onlyOverseer {
        treatyCount++;
        treaties[treatyCount] = SightRule(treatyCount, principle, description, block.timestamp);
        emit SightRuleDeclared(treatyCount, principle, description);
    }
}

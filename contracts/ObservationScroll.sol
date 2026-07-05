pragma solidity ^0.8.20;

contract ObservationScroll {
    address public overseer;
    uint256 public scrollCount;

    struct ObservationRule {
        uint256 id;
        string principle;   // Awareness, Perception, Vigilance
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => ObservationRule) public rules;
    event ObservationRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareObservationRule(string calldata principle, string calldata description) external onlyOverseer {
        scrollCount++;
        rules[scrollCount] = ObservationRule(scrollCount, principle, description, block.timestamp);
        emit ObservationRuleDeclared(scrollCount, principle, description);
    }
}

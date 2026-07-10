pragma solidity ^0.8.20;

contract OpenCommunicationScroll {
    address public overseer;
    uint256 public scrollCount;

    struct CommunicationRule {
        uint256 id;
        string principle;   // Open Communication, Transparent Dialogue
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => CommunicationRule) public rules;
    event CommunicationRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareCommunicationRule(string calldata principle, string calldata description) external onlyOverseer {
        scrollCount++;
        rules[scrollCount] = CommunicationRule(scrollCount, principle, description, block.timestamp);
        emit CommunicationRuleDeclared(scrollCount, principle, description);
    }
}

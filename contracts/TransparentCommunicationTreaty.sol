pragma solidity ^0.8.20;

contract TransparentCommunicationTreaty {
    address public overseer;
    uint256 public treatyCount;

    struct CommunicationRule {
        uint256 id;
        string principle;   // Transparent Communication, Openness
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => CommunicationRule) public treaties;
    event CommunicationRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareCommunicationRule(string calldata principle, string calldata description) external onlyOverseer {
        treatyCount++;
        treaties[treatyCount] = CommunicationRule(treatyCount, principle, description, block.timestamp);
        emit CommunicationRuleDeclared(treatyCount, principle, description);
    }
}

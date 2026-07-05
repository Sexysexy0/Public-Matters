pragma solidity ^0.8.20;

contract ThrivingCommunitiesTreaty {
    address public overseer;
    uint256 public treatyCount;

    struct CommunityRule {
        uint256 id;
        string principle;   // Thriving Communities, Collective Growth
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => CommunityRule) public treaties;
    event CommunityRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareCommunityRule(string calldata principle, string calldata description) external onlyOverseer {
        treatyCount++;
        treaties[treatyCount] = CommunityRule(treatyCount, principle, description, block.timestamp);
        emit CommunityRuleDeclared(treatyCount, principle, description);
    }
}

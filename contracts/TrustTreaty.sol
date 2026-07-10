pragma solidity ^0.8.20;

contract TrustTreaty {
    address public overseer;
    uint256 public treatyCount;

    struct TrustRule {
        uint256 id;
        string principle;   // Trust, Transparency, Reliability
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => TrustRule) public treaties;
    event TrustRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareTrustRule(string calldata principle, string calldata description) external onlyOverseer {
        treatyCount++;
        treaties[treatyCount] = TrustRule(treatyCount, principle, description, block.timestamp);
        emit TrustRuleDeclared(treatyCount, principle, description);
    }
}

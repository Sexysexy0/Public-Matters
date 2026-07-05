pragma solidity ^0.8.20;

contract EndOfPathTreaty {
    address public overseer;
    uint256 public treatyCount;

    struct PathRule {
        uint256 id;
        string principle;   // End of Path, Closure
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => PathRule) public treaties;
    event PathRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declarePathRule(string calldata principle, string calldata description) external onlyOverseer {
        treatyCount++;
        treaties[treatyCount] = PathRule(treatyCount, principle, description, block.timestamp);
        emit PathRuleDeclared(treatyCount, principle, description);
    }
}

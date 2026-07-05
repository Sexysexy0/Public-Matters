pragma solidity ^0.8.20;

contract RightViewTreaty {
    address public overseer;
    uint256 public treatyCount;

    struct ViewRule {
        uint256 id;
        string principle;   // Right View, Literacy of Reality
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => ViewRule) public treaties;
    event ViewRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareViewRule(string calldata principle, string calldata description) external onlyOverseer {
        treatyCount++;
        treaties[treatyCount] = ViewRule(treatyCount, principle, description, block.timestamp);
        emit ViewRuleDeclared(treatyCount, principle, description);
    }
}

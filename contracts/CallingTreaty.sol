pragma solidity ^0.8.20;

contract CallingTreaty {
    address public overseer;
    uint256 public treatyCount;

    struct CallingRule {
        uint256 id;
        string principle;   // True Calling, Faith, Courage
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => CallingRule) public treaties;
    event CallingRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareCallingRule(string calldata principle, string calldata description) external onlyOverseer {
        treatyCount++;
        treaties[treatyCount] = CallingRule(treatyCount, principle, description, block.timestamp);
        emit CallingRuleDeclared(treatyCount, principle, description);
    }
}

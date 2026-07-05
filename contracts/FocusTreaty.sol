pragma solidity ^0.8.20;

contract FocusTreaty {
    address public overseer;
    uint256 public treatyCount;

    struct FocusRule {
        uint256 id;
        string principle;   // Concentration, Clarity, Directed Effort
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => FocusRule) public treaties;
    event FocusRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareFocusRule(string calldata principle, string calldata description) external onlyOverseer {
        treatyCount++;
        treaties[treatyCount] = FocusRule(treatyCount, principle, description, block.timestamp);
        emit FocusRuleDeclared(treatyCount, principle, description);
    }
}

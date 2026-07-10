pragma solidity ^0.8.20;

contract RestorationScroll {
    address public overseer;
    uint256 public scrollCount;

    struct RestorationRule {
        uint256 id;
        string principle;   // Healing, Renewal, Balance
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => RestorationRule) public rules;
    event RestorationRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareRestorationRule(string calldata principle, string calldata description) external onlyOverseer {
        scrollCount++;
        rules[scrollCount] = RestorationRule(scrollCount, principle, description, block.timestamp);
        emit RestorationRuleDeclared(scrollCount, principle, description);
    }
}

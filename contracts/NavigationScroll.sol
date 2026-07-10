pragma solidity ^0.8.20;

contract NavigationScroll {
    address public overseer;
    uint256 public scrollCount;

    struct NavigationRule {
        uint256 id;
        string principle;   // Guidance, Orientation, Purposeful Direction
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => NavigationRule) public rules;
    event NavigationRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareNavigationRule(string calldata principle, string calldata description) external onlyOverseer {
        scrollCount++;
        rules[scrollCount] = NavigationRule(scrollCount, principle, description, block.timestamp);
        emit NavigationRuleDeclared(scrollCount, principle, description);
    }
}

pragma solidity ^0.8.20;

/// @title ScientificFrontierScroll
/// @notice Encodes covenant for pushing scientific frontiers.
/// @dev Anchors innovation, exploration, and safeguard rules.

contract ScientificFrontierScroll {
    address public overseer;
    uint256 public scrollCount;

    struct FrontierRule {
        uint256 id;
        string principle;   // Innovation, Exploration, Safeguard
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => FrontierRule> public rules;
    event FrontierRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareFrontierRule(string calldata principle, string calldata description) external onlyOverseer {
        scrollCount++;
        rules[scrollCount] = FrontierRule(scrollCount, principle, description, block.timestamp);
        emit FrontierRuleDeclared(scrollCount, principle, description);
    }
}

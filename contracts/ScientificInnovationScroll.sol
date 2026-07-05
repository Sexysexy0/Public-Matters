pragma solidity ^0.8.20;

/// @title ScientificInnovationScroll
/// @notice Encodes covenant for innovation ethics in science.
/// @dev Anchors innovation, ethics, and safeguard rules.

contract ScientificInnovationScroll {
    address public overseer;
    uint256 public scrollCount;

    struct InnovationRule {
        uint256 id;
        string principle;   // Innovation, Ethics, Safeguard
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => InnovationRule> public rules;
    event InnovationRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareInnovationRule(string calldata principle, string calldata description) external onlyOverseer {
        scrollCount++;
        rules[scrollCount] = InnovationRule(scrollCount, principle, description, block.timestamp);
        emit InnovationRuleDeclared(scrollCount, principle, description);
    }
}

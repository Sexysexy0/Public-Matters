pragma solidity ^0.8.20;

/// @title SystemicCareScroll
/// @notice Covenant for systemic care safeguards.
/// @dev Anchors fairness, empathy, and governance in care systems.

contract SystemicCareScroll {
    address public overseer;
    uint256 public scrollCount;

    struct CareRule {
        uint256 id;
        string principle;   // Systemic Care, Fairness, Empathy
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => CareRule) public rules;
    event CareRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareCareRule(string calldata principle, string calldata description) external onlyOverseer {
        scrollCount++;
        rules[scrollCount] = CareRule(scrollCount, principle, description, block.timestamp);
        emit CareRuleDeclared(scrollCount, principle, description);
    }
}

pragma solidity ^0.8.20;

/// @title FoodSecurityTreaty
/// @notice Covenant for global food security.
/// @dev Anchors fairness, resilience, and survival.

contract FoodSecurityTreaty {
    address public overseer;
    uint256 public treatyCount;

    struct FoodRule {
        uint256 id;
        string principle;   // Food Security, Fairness, Survival
        string description;
        uint256 timestamp;
    }

    mapping(uint256 => FoodRule) public treaties;
    event FoodRuleDeclared(uint256 indexed id, string principle, string description);

    constructor(address _overseer) { overseer = _overseer; }
    modifier onlyOverseer() { require(msg.sender == overseer, "Not authorized"); _; }

    function declareFoodRule(string calldata principle, string calldata description) external onlyOverseer {
        treatyCount++;
        treaties[treatyCount] = FoodRule(treatyCount, principle, description, block.timestamp);
        emit FoodRuleDeclared(treatyCount, principle, description);
    }
}

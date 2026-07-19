// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title ElephantStrategyCodex
/// @notice Covenant contract encoding Britain's 6 rules for defeating continental powers
contract ElephantStrategyCodex {
    address public strategist;
    uint256 public minimumReserves;

    struct RuleArc {
        string ruleName;
        string description;
        uint256 timestamp;
        bool enforced;
    }

    RuleArc[] public rules;

    event RuleRecorded(string ruleName, string description, uint256 timestamp, bool enforced);
    event ReservesUpdated(uint256 newReserves, uint256 timestamp);

    modifier onlyStrategist() {
        require(msg.sender == strategist, "Not authorized");
        _;
    }

    constructor(uint256 _minimumReserves) {
        strategist = msg.sender;
        minimumReserves = _minimumReserves;
    }

    /// @notice Update minimum reserves (economic foundation)
    function updateReserves(uint256 _newReserves) public onlyStrategist {
        minimumReserves = _newReserves;
        emit ReservesUpdated(_newReserves, block.timestamp);
    }

    /// @notice Record a strategic rule
    function recordRule(string memory ruleName, string memory description, bool enforced) public onlyStrategist {
        RuleArc memory arc = RuleArc(ruleName, description, block.timestamp, enforced);
        rules.push(arc);
        emit RuleRecorded(ruleName, description, block.timestamp, enforced);
    }

    /// @notice Retrieve a rule by index
    function getRule(uint256 index) public view returns (string memory, string memory, uint256, bool) {
        RuleArc memory arc = rules[index];
        return (arc.ruleName, arc.description, arc.timestamp, arc.enforced);
    }

    /// @notice Get total number of rules recorded
    function getRuleCount() public view returns (uint256) {
        return rules.length;
    }
}

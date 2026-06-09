// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title TechHumilityCodex
/// @notice Covenant contract to safeguard human dignity and override rights in automated systems
contract TechHumilityCodex {
    address public owner;

    struct OverrideClause {
        string system;        // e.g. "Smart Home", "AI Governance", "IoT Network"
        string safeguard;     // description of human override safeguard
        bool active;
        uint256 timestamp;
    }

    OverrideClause[] public clauses;

    event OverrideActivated(string system, string safeguard, bool active, uint256 timestamp);

    modifier onlyOwner() {
        require(msg.sender == owner, "Not authorized");
        _;
    }

    constructor() {
        owner = msg.sender;
    }

    /// @notice Activate a human override safeguard for a system
    function activateOverride(string memory system, string memory safeguard, bool active) public onlyOwner {
        OverrideClause memory newClause = OverrideClause(system, safeguard, active, block.timestamp);
        clauses.push(newClause);
        emit OverrideActivated(system, safeguard, active, block.timestamp);
    }

    function getClause(uint256 index) public view returns (string memory, string memory, bool, uint256) {
        OverrideClause memory c = clauses[index];
        return (c.system, c.safeguard, c.active, c.timestamp);
    }

    function getClauseCount() public view returns (uint256) {
        return clauses.length;
    }
}

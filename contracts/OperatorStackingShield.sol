// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title OperatorStackingShield
/// @notice Shield covenant to enforce squad stacking limits for operators
contract OperatorStackingShield {
    address public overseer;
    uint256 public shieldCount;
    uint256 public maxStack; // maximum allowed per operator in squad

    struct StackingRecord {
        uint256 id;
        string operator;   // operator name (e.g., N-TWO)
        uint256 allowed;   // max allowed in squad
        string notes;      // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => StackingRecord) public records;

    event StackingLogged(uint256 indexed id, string operator, uint256 allowed, string notes);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer, uint256 _maxStack) {
        overseer = _overseer;
        maxStack = _maxStack;
    }

    /// @notice Overseer logs stacking limit record
    function logStacking(string calldata operator, uint256 allowed, string calldata notes) external onlyOverseer {
        shieldCount++;
        records[shieldCount] = StackingRecord({
            id: shieldCount,
            operator: operator,
            allowed: allowed,
            notes: notes,
            timestamp: block.timestamp
        });
        emit StackingLogged(shieldCount, operator, allowed, notes);
    }

    /// @notice Citizens can view stacking limit records
    function viewStacking(uint256 id) external view returns (StackingRecord memory) {
        return records[id];
    }

    /// @notice Overseer can update global max stack
    function updateMaxStack(uint256 newMax) external onlyOverseer {
        maxStack = newMax;
    }
}

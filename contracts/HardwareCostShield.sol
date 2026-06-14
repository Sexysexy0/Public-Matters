// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title HardwareCostShield
/// @notice Shield covenant to record and mitigate rising hardware component costs
contract HardwareCostShield {
    address public overseer;
    uint256 public shieldCount;

    struct CostRecord {
        uint256 id;
        string component;   // GPU, CPU, RAM, SSD
        uint256 projectedCost; // relative cost index (e.g., 5x higher)
        string mitigation;  // optimization, scalable design, consumer strategy
        string notes;       // contextual application
        uint256 timestamp;
    }

    mapping(uint256 => CostRecord) public records;

    event CostLogged(uint256 indexed id, string component, uint256 projectedCost, string mitigation);

    modifier onlyOverseer() {
        require(msg.sender == overseer, "Not authorized");
        _;
    }

    constructor(address _overseer) {
        overseer = _overseer;
    }

    /// @notice Overseer logs hardware cost record
    function logCost(string calldata component, uint256 projectedCost, string calldata mitigation, string calldata notes) external onlyOverseer {
        shieldCount++;
        records[shieldCount] = CostRecord({
            id: shieldCount,
            component: component,
            projectedCost: projectedCost,
            mitigation: mitigation,
            notes: notes,
            timestamp: block.timestamp
        });
        emit CostLogged(shieldCount, component, projectedCost, mitigation);
    }

    /// @notice Citizens can view hardware cost records
    function viewCost(uint256 id) external view returns (CostRecord memory) {
        return records[id];
    }
}

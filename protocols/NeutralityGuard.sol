// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// NeutralityGuard: ensure fairness by balancing exemptions with alternative revenue sources
contract NeutralityGuard {
    struct Balance {
        uint256 id;
        string measure;       // e.g., "Luxury tax", "Corporate efficiency"
        uint256 projectedRevenue;
        bool active;
        uint256 timestamp;
    }

    uint256 public nextId;
    mapping(uint256 => Balance) public balances;
    address public steward;

    event BalanceSet(uint256 indexed id, string measure, uint256 projectedRevenue);

    constructor() { steward = msg.sender; }

    function setBalance(string calldata measure, uint256 projectedRevenue, bool active) external {
        require(msg.sender == steward, "Only steward");
        balances[nextId] = Balance(nextId, measure, projectedRevenue, active, block.timestamp);
        emit BalanceSet(nextId, measure, projectedRevenue);
        nextId++;
    }

    function toggle(uint256 id, bool active) external {
        require(msg.sender == steward, "Only steward");
        balances[id].active = active;
    }
}

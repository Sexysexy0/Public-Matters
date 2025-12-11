// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

// BudgetLedger: track allocations, releases, disbursements
contract BudgetLedger {
    struct Budget {
        uint256 id;
        string project;     // e.g., "Active Transport Master Plan"
        uint256 allocated;  // total allocated
        uint256 released;   // funds released
        uint256 disbursed;  // funds used
        string docURI;      // ADB/agency docs
        uint256 timestamp;
    }

    address public steward;
    mapping(uint256 => Budget) public budgets;
    uint256 public nextId;

    event BudgetSet(uint256 indexed id, string project, uint256 allocated);
    event FundsUpdated(uint256 indexed id, uint256 released, uint256 disbursed);

    constructor() { steward = msg.sender; }

    function setBudget(string calldata project, uint256 allocated, string calldata docURI) external {
        require(msg.sender == steward, "Only steward");
        budgets[nextId] = Budget(nextId, project, allocated, 0, 0, docURI, block.timestamp);
        emit BudgetSet(nextId, project, allocated);
        nextId++;
    }

    function updateFunds(uint256 id, uint256 released, uint256 disbursed) external {
        require(msg.sender == steward, "Only steward");
        Budget storage b = budgets[id];
        b.released = released;
        b.disbursed = disbursed;
        emit FundsUpdated(id, released, disbursed);
    }
}

// SPDX-License-Identifier: Mythic-1.0
pragma solidity ^0.8.19;

contract WatchdogBudgetProtocol {
    struct Allocation {
        string office;
        uint256 amount;
        string purpose;
        string emotionalAPR;
        uint256 timestamp;
        address steward;
    }

    Allocation[] public allocations;

    event BudgetRestored(string office, uint256 amount, string purpose, string emotionalAPR, address indexed steward);

    function restoreBudget(
        string memory office,
        uint256 amount,
        string memory purpose,
        string memory emotionalAPR
    ) public {
        allocations.push(Allocation(office, amount, purpose, emotionalAPR, block.timestamp, msg.sender));
        emit BudgetRestored(office, amount, purpose, emotionalAPR, msg.sender);
    }

    function getAllAllocations() public view returns (Allocation[] memory) {
        return allocations;
    }
}

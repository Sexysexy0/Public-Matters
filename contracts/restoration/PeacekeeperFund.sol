// SPDX-License-Identifier: Mythic-1.0
pragma solidity ^0.8.19;

contract PeacekeeperFund {
    struct Allocation {
        string unitName;
        uint256 amount;
        string purpose;
        string emotionalSupport;
        uint256 timestamp;
        address steward;
    }

    Allocation[] public allocations;

    event FundAllocated(string unitName, uint256 amount, string purpose, string emotionalSupport, address indexed steward);

    function allocate(
        string memory unitName,
        uint256 amount,
        string memory purpose,
        string memory emotionalSupport
    ) public {
        allocations.push(Allocation(unitName, amount, purpose, emotionalSupport, block.timestamp, msg.sender));
        emit FundAllocated(unitName, amount, purpose, emotionalSupport, msg.sender);
    }

    function getAllAllocations() public view returns (Allocation[] memory) {
        return allocations;
    }
}

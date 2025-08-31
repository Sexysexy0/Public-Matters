// SPDX-License-Identifier: Mythic-1.0
pragma solidity ^0.8.19;

contract PressSanctumFund {
    struct Allocation {
        string vendor;
        string item;
        uint256 amount;
        string emotionalAPR;
        uint256 timestamp;
        address steward;
    }

    Allocation[] public allocations;

    event FundAllocated(string vendor, string item, uint256 amount, string emotionalAPR, address indexed steward);

    function allocate(
        string memory vendor,
        string memory item,
        uint256 amount,
        string memory emotionalAPR
    ) public {
        allocations.push(Allocation(vendor, item, amount, emotionalAPR, block.timestamp, msg.sender));
        emit FundAllocated(vendor, item, amount, emotionalAPR, msg.sender);
    }

    function getAllAllocations() public view returns (Allocation[] memory) {
        return allocations;
    }
}

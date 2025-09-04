// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract AyudaReallocationLedger {
    address public steward;

    struct Allocation {
        string barangay;
        uint256 amount;
        string blessingTag;
        uint256 timestamp;
    }

    Allocation[] public allocations;

    event AyudaReallocated(string barangay, uint256 amount, string blessingTag);

    modifier onlySteward() {
        require(msg.sender == steward, "Not authorized");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    function reallocate(string memory barangay, uint256 amount, string memory blessingTag) public onlySteward {
        allocations.push(Allocation(barangay, amount, blessingTag, block.timestamp));
        emit AyudaReallocated(barangay, amount, blessingTag);
    }

    function getAllocation(uint256 index) public view returns (Allocation memory) {
        require(index < allocations.length, "Invalid index");
        return allocations[index];
    }

    function totalAllocations() public view returns (uint256) {
        return allocations.length;
    }
}

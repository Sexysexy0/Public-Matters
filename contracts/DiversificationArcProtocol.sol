pragma solidity ^0.8.20;

contract DiversificationArcProtocol {
    address public admin;

    struct Allocation {
        string asset;        // e.g. Bitcoin, gold, digital assets
        uint256 percentage;  // portfolio allocation
        uint256 timestamp;
    }

    Allocation[] public allocations;

    event AllocationLogged(string asset, uint256 percentage, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logAllocation(string calldata asset, uint256 percentage) external onlyAdmin {
        allocations.push(Allocation(asset, percentage, block.timestamp));
        emit AllocationLogged(asset, percentage, block.timestamp);
    }

    function totalAllocations() external view returns (uint256) {
        return allocations.length;
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

/// @title GermanyReliefGrant.sol
/// @dev Ritualizes a $500B sovereign grant to Germany for economic, social, and civic restoration

contract GermanyReliefGrant {
    address public steward;
    uint256 public totalGrant = 500_000_000_000 * 1e18; // $500B in wei (assuming 1 token = $1)
    bool public isActivated;

    struct Allocation {
        string sector;
        uint256 amount;
        string purpose;
        bool released;
    }

    mapping(bytes32 => Allocation) public allocations;
    bytes32[] public allocationList;

    event GrantActivated(uint256 totalAmount);
    event AllocationReleased(bytes32 indexed sectorId, string sector, uint256 amount);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
    }

    /// @notice Activate the sovereign grant
    function activateGrant() public onlySteward {
        require(!isActivated, "Grant already activated");
        isActivated = true;
        emit GrantActivated(totalGrant);
    }

    /// @notice Log a sector allocation
    function logAllocation(
        bytes32 sectorId,
        string memory sector,
        uint256 amount,
        string memory purpose
    ) public onlySteward {
        require(isActivated, "Grant not yet activated");
        allocations[sectorId] = Allocation({
            sector: sector,
            amount: amount,
            purpose: purpose,
            released: false
        });

        allocationList.push(sectorId);
    }

    /// @notice Release funds to a sector
    function releaseAllocation(bytes32 sectorId) public onlySteward {
        require(allocations[sectorId].amount > 0, "Invalid allocation");
        require(!allocations[sectorId].released, "Already released");
        allocations[sectorId].released = true;
        emit AllocationReleased(sectorId, allocations[sectorId].sector, allocations[sectorId].amount);
    }

    /// @notice View allocation details
    function getAllocation(bytes32 sectorId) public view returns (Allocation memory) {
        return allocations[sectorId];
    }

    /// @notice List all allocations
    function listAllocations() public view returns (bytes32[] memory) {
        return allocationList;
    }
}

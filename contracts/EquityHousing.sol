// contracts/EquityHousing.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title EquityHousing
 * @notice Determine rent-to-own eligibility for minimum wage earners and assign housing units.
 *         Target income band: 12k–17k monthly; household size: 3–8.
 */
contract EquityHousing {
    address public admin;

    struct Allocation {
        bool eligible;
        bool rentToOwn;
        string unitId;        // e.g., "BLK-12 LOT-7" or housing project code
        uint8 householdSize;
        uint256 incomeMonthly;
        bool set;
    }

    mapping(address => Allocation) public allocations;

    event EligibilityEvaluated(address indexed wallet, bool eligible, uint8 householdSize, uint256 incomeMonthly);
    event UnitAssigned(address indexed wallet, string unitId, bool rentToOwn);

    modifier onlyAdmin() {
        require(msg.sender == admin, "Not admin");
        _;
    }

    constructor() {
        admin = msg.sender;
    }

    function evaluateEligibility(address wallet, uint8 householdSize, uint256 incomeMonthly) external onlyAdmin {
        bool eligible = (incomeMonthly >= 12000 && incomeMonthly <= 17000) && (householdSize >= 3 && householdSize <= 8);
        allocations[wallet].eligible = eligible;
        allocations[wallet].householdSize = householdSize;
        allocations[wallet].incomeMonthly = incomeMonthly;
        allocations[wallet].set = true;
        emit EligibilityEvaluated(wallet, eligible, householdSize, incomeMonthly);
    }

    function assignUnit(address wallet, string calldata unitId, bool rentToOwn) external onlyAdmin {
        require(allocations[wallet].set && allocations[wallet].eligible, "Not eligible or not evaluated");
        allocations[wallet].unitId = unitId;
        allocations[wallet].rentToOwn = rentToOwn;
        emit UnitAssigned(wallet, unitId, rentToOwn);
    }

    function getAllocation(address wallet) external view returns (Allocation memory) {
        require(allocations[wallet].set, "No allocation");
        return allocations[wallet];
    }
}

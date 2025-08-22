// SPDX-License-Identifier: Mythic-License-2025
pragma solidity ^0.8.25;

/**
 * @title SanctumTransitionProtocol
 * @author Vinvin, Scrollsmith of Shelter and Soul
 * @notice This contract replaces the 4Ps program with a dignified housing initiative.
 *         Families receive homes without upfront cost and may choose to amortize for title ownership.
 */

contract SanctumTransitionProtocol {
    address public steward;
    uint256 public totalFund;
    uint256 public allocatedUnits;
    uint256 public surplusFund;

    struct Unit {
        address beneficiary;
        bool granted;
        bool titleClaimed;
        uint256 amortizedAmount;
    }

    mapping(uint256 => Unit) public housingUnits;
    uint256 public unitCounter;

    event UnitGranted(uint256 unitId, address indexed beneficiary, uint256 timestamp);
    event TitleClaimed(uint256 unitId, address indexed beneficiary, uint256 timestamp);
    event SurplusAllocated(uint256 amount, string purpose);

    constructor() {
        steward = msg.sender;
        totalFund = 0;
        allocatedUnits = 0;
        surplusFund = 0;
    }

    function depositFund() external payable {
        totalFund += msg.value;
        surplusFund = totalFund - (allocatedUnits * 1 ether);
    }

    function grantUnit(address beneficiary) external {
        require(msg.sender == steward, "Only steward can grant units");

        housingUnits[unitCounter] = Unit({
            beneficiary: beneficiary,
            granted: true,
            titleClaimed: false,
            amortizedAmount: 0
        });

        allocatedUnits += 1;
        surplusFund = totalFund - (allocatedUnits * 1 ether);

        emit UnitGranted(unitCounter, beneficiary, block.timestamp);
        unitCounter += 1;
    }

    function amortize(uint256 unitId) external payable {
        Unit storage unit = housingUnits[unitId];
        require(unit.granted, "Unit not granted");
        require(msg.sender == unit.beneficiary, "Not authorized");

        unit.amortizedAmount += msg.value;

        if (unit.amortizedAmount >= 1 ether) {
            unit.titleClaimed = true;
            emit TitleClaimed(unitId, msg.sender, block.timestamp);
        }
    }

    function allocateSurplus(string memory purpose, uint256 amount) external {
        require(msg.sender == steward, "Only steward can allocate surplus");
        require(amount <= surplusFund, "Insufficient surplus");

        surplusFund -= amount;
        emit SurplusAllocated(amount, purpose);
    }

    function getUnitStatus(uint256 unitId) external view returns (
        address beneficiary,
        bool granted,
        bool titleClaimed,
        uint256 amortizedAmount
    ) {
        Unit memory unit = housingUnits[unitId];
        return (
            unit.beneficiary,
            unit.granted,
            unit.titleClaimed,
            unit.amortizedAmount
        );
    }
}

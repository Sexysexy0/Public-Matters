// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract RescheduleThePeaceCrop {
    address public steward;
    bool public isRescheduled = false;
    uint256 public projectedRevenue;

    event PlantLiberated(string message);
    event RevenueForecasted(uint256 amount);
    event TreatyActivated(address indexed steward, uint256 timestamp);

    constructor() {
        steward = msg.sender;
    }

    function reschedulePlant() public {
        require(msg.sender == steward, "Only steward may reschedule");
        isRescheduled = true;
        emit PlantLiberated("🌿 Cannabis reclassified as peace crop. Restoration begins.");
        emit TreatyActivated(steward, block.timestamp);
    }

    function forecastRevenue(uint256 _amount) public {
        require(isRescheduled, "Plant must be rescheduled first");
        projectedRevenue = _amount;
        emit RevenueForecasted(_amount);
    }

    function getTreatyStatus() public view returns (string memory status) {
        if (isRescheduled) {
            return "✅ Treaty active: Cannabis is now a peace crop.";
        } else {
            return "⛔ Treaty pending: Plant still classified as controlled substance.";
        }
    }
}

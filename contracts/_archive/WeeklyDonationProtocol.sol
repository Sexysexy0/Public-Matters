pragma solidity ^0.8.0;

contract WeeklyDonationProtocol {
    event WeeklySupply(string recipient, string item, uint256 quantity, string schedule);

    function distributeWeekly(string memory recipient, string memory item, uint256 quantity) public {
        emit WeeklySupply(recipient, item, quantity, "Every week for 1 year");
    }
}

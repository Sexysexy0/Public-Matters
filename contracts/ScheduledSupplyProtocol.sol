pragma solidity ^0.8.0;

contract ScheduledSupplyProtocol {
    event SupplyDrop(string recipient, string item, uint256 quantity, string schedule);

    function distribute(string memory recipient, string memory item, uint256 quantity) public {
        emit SupplyDrop(recipient, item, quantity, "Weekly for 1 year");
    }
}

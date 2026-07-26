pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract DriverEquityLedger is Ownable {

    constructor() Ownable(msg.sender) {}

    event EquityAlert(string driverType, string issue);

    function checkInclusion(string memory driverType, bool included) public {
        if (!included) {
            emit EquityAlert(driverType, "Driver excluded – equity safeguard required");
        }
    }
}

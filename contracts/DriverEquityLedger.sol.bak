pragma solidity ^0.8.0;

contract DriverEquityLedger {
    event EquityAlert(string driverType, string issue);

    function checkInclusion(string memory driverType, bool included) public {
        if (!included) {
            emit EquityAlert(driverType, "Driver excluded – equity safeguard required");
        }
    }
}

pragma solidity ^0.8.0;

contract DriverTransparencyLedger {
    event TransparencyAlert(string driverType, string issue);

    function checkDriver(string memory driverType, bool included) public {
        if (!included) {
            emit TransparencyAlert(driverType, "Driver excluded – inclusion safeguard required");
        }
    }
}

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract DriverTransparencyLedger is Ownable {

    constructor() Ownable(msg.sender) {}

    event TransparencyAlert(string driverType, string issue);

    function checkDriver(string memory driverType, bool included) public {
        if (!included) {
            emit TransparencyAlert(driverType, "Driver excluded – inclusion safeguard required");
        }
    }
}

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract FuelEquityLedger is Ownable {

    constructor() Ownable(msg.sender) {}

    event EquityAlert(string recipient, string issue);

    function checkDistribution(string memory recipient, bool received) public {
        if (!received) {
            emit EquityAlert(recipient, "Fuel coupon excluded – inclusion safeguard required");
        }
    }
}

pragma solidity ^0.8.0;

contract FuelEquityLedger {
    event EquityAlert(string recipient, string issue);

    function checkDistribution(string memory recipient, bool received) public {
        if (!received) {
            emit EquityAlert(recipient, "Fuel coupon excluded – inclusion safeguard required");
        }
    }
}

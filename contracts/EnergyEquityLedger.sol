pragma solidity ^0.8.0;

contract EnergyEquityLedger {
    event EquityAlert(string sector, string issue);

    function checkInclusion(string memory sector, bool included) public {
        if (!included) {
            emit EquityAlert(sector, "Sector excluded – energy inclusion safeguard required");
        }
    }
}

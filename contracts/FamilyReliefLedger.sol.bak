pragma solidity ^0.8.0;

contract FamilyReliefLedger {
    event EquityAlert(string family, string issue);

    function checkInclusion(string memory family, bool included) public {
        if (!included) {
            emit EquityAlert(family, "Family excluded – relief safeguard required");
        }
    }
}

pragma solidity ^0.8.0;

contract ClaimEquityLedger {
    event EquityAlert(string family, string issue);

    function checkDistribution(string memory family, bool received) public {
        if (!received) {
            emit EquityAlert(family, "Family excluded – insurance safeguard required");
        }
    }
}

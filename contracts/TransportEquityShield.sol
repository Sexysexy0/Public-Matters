pragma solidity ^0.8.0;

contract TransportEquityShield {
    event EquityAlert(string group, string issue);

    function checkEnforcement(string memory group, bool disproportionate) public {
        if (disproportionate) {
            emit EquityAlert(group, "Disproportionate enforcement detected – fairness safeguard required");
        }
    }
}

pragma solidity ^0.8.0;

contract ProportionalEnforcementShield {
    event ProportionalityAlert(string group, string issue);

    function checkEnforcement(string memory group, bool concentrated) public {
        if (concentrated) {
            emit ProportionalityAlert(group, "Enforcement disproportionate – fairness safeguard required");
        }
    }
}

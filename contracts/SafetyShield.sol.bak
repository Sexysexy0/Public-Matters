pragma solidity ^0.8.0;

contract SafetyShield {
    event SafetyAlert(string facility, string issue);

    function detectRisk(string memory facility, bool risk) public {
        if (risk) {
            emit SafetyAlert(facility, "Nuclear risk detected – safety safeguard required");
        }
    }
}

pragma solidity ^0.8.0;

contract GlobalPeaceShield {
    event PeaceAlert(string partners, string issue);

    function detectEscalation(string memory partners, bool escalationRisk) public {
        if (escalationRisk) {
            emit PeaceAlert(partners, "Escalation risk detected – peace safeguard required");
        }
    }
}

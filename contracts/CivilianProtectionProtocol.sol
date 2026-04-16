pragma solidity ^0.8.0;

contract CivilianProtectionProtocol {
    event ProtectionAlert(string facility, string issue);

    function detectAttack(string memory facility, bool civilianTarget) public {
        if (civilianTarget) {
            emit ProtectionAlert(facility, "Civilian facility attacked – safeguard activated");
        }
    }
}

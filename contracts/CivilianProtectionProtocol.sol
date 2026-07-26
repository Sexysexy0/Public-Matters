pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract CivilianProtectionProtocol is Ownable {

    constructor() Ownable(msg.sender) {}

    event ProtectionAlert(string facility, string issue);

    function detectAttack(string memory facility, bool civilianTarget) public {
        if (civilianTarget) {
            emit ProtectionAlert(facility, "Civilian facility attacked – safeguard activated");
        }
    }
}

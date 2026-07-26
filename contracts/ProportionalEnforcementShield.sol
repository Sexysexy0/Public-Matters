pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract ProportionalEnforcementShield is Ownable {

    constructor() Ownable(msg.sender) {}

    event ProportionalityAlert(string group, string issue);

    function checkEnforcement(string memory group, bool concentrated) public {
        if (concentrated) {
            emit ProportionalityAlert(group, "Enforcement disproportionate – fairness safeguard required");
        }
    }
}

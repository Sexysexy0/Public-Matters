pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract SafetyShield is Ownable {

    constructor() Ownable(msg.sender) {}

    event SafetyAlert(string facility, string issue);

    function detectRisk(string memory facility, bool risk) public {
        if (risk) {
            emit SafetyAlert(facility, "Nuclear risk detected – safety safeguard required");
        }
    }
}

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract SchoolSafetyProtocol is Ownable {

    constructor() Ownable(msg.sender) {}

    event SafetyAlert(string school, string issue);

    function detectThreat(string memory school, bool attacked) public {
        if (attacked) {
            emit SafetyAlert(school, "School attacked – civilian protection safeguard activated");
        }
    }
}

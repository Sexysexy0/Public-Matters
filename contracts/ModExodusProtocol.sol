pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract ModExodusProtocol is Ownable {

    constructor() Ownable(msg.sender) {}

    event CommunityAlert(string issue, string detail);

    function detectExodus(bool modsLeft) public {
        if (modsLeft) {
            emit CommunityAlert("Moderation Exodus", "Safeguard required – stabilize community impact");
        }
    }
}

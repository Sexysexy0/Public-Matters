// NeutralPassageProtocol.sol
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract NeutralPassageProtocol is Ownable {

    constructor() Ownable(msg.sender) {}

    bool public usBlockadeLifted;
    bool public straitOpen;

    function syncDiplomaticStatus(bool _blockadeStatus) public {
        usBlockadeLifted = _blockadeStatus;
        if(usBlockadeLifted) {
            straitOpen = true; // Strait returns to general traffic (0:08)
        }
    }
}

// SandboxModeEnabler.sol
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";

contract SandboxModeEnabler is Ownable {

    constructor() Ownable(msg.sender) {}

    bool public isQuestLockActive;

    // Bubuksan ang buong mundo para sa "Free Roam"
    function toggleZenMode(bool _status) public {
        isQuestLockActive = !_status;
        // Logic: Disables AI Aggression and World Gates
        // Play at your own pace, explore without limits
    }
}

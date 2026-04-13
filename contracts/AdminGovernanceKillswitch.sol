// AdminGovernanceKillswitch.sol
pragma solidity ^0.8.0;

contract AdminGovernanceKillswitch {
    bool public systemPaused = false;

    function triggerEmergencyPause() public {
        // Goal: Community-led Security.
        // The power to stop a heist is in the hands of the many, not the one.
        systemPaused = true;
    }
}

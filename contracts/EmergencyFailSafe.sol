// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract EmergencyFailSafe {
    // [0:58-1:26] Auto pull-over and hazard activation
    function triggerEmergency(bool _driverConscious) public pure returns (string memory) {
        if (!_driverConscious) {
            return "SIGNAL: INCAPACITATED. Deploy Hazards. Execute Safe Pull-Over.";
        }
        return "SIGNAL: Pilot Active.";
    }
}

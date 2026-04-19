// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract ProneMovementModule {
    enum Stance { Standing, Crouching, Prone }

    // [REQUEST: "Yo they better put the prone mechanic in there"]
    function updateStance(Stance _newStance) public pure returns (string memory) {
        if (_newStance == Stance.Prone) {
            return "STATUS: Low Profile Active. Stealth and Accuracy buffed.";
        }
        return "STATUS: Standard Mobility.";
    }
}

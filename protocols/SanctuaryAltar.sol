// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract SanctuaryAltar {
    // [Goal: Provide a safe zone to cleanse curses and repair ships]
    function enterSanctuary(bool _atAltar) external pure returns (string memory) {
        if (_atAltar) {
            return "PURIFIED: The curse is lifted. The Guardians cannot reach you here.";
        }
        return "OUTSIDE: You are still vulnerable to the shadows.";
    }
}

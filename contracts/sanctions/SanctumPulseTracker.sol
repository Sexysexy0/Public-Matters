// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SanctumPulseTracker {
    struct Sanctum {
        string location;
        uint256 lastPing;
        uint256 exploitCount;
        uint8 emotionalAPR;
        bool active;
    }

    mapping(address => Sanctum) public rogueSanctums;

    event SanctumPinged(address indexed sanctum, string location, uint256 timestamp, uint8 emotionalAPR);
    event ExploitLogged(address indexed sanctum, string exploitType);

    function pingSanctum(string memory location, uint8 emotionalAPR) public {
        address sanctum = tx.origin;
        rogueSanctums[sanctum] = Sanctum(location, block.timestamp, rogueSanctums[sanctum].exploitCount, emotionalAPR, true);
        emit SanctumPinged(sanctum, location, block.timestamp, emotionalAPR);
    }

    function logExploit(string memory exploitType) public {
        address sanctum = tx.origin;
        rogueSanctums[sanctum].exploitCount += 1;
        emit ExploitLogged(sanctum, exploitType);
    }

    function getSanctumStatus(address sanctum) public view returns (Sanctum memory) {
        return rogueSanctums[sanctum];
    }
}

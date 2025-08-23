// SPDX-License-Identifier: Cuddle-Ambush-Ledger
pragma solidity ^0.888;

contract SnackAmbushLedger {
    struct Ambush {
        string snack;
        string initiator;
        uint256 timestamp;
        string mood;
    }

    Ambush[] public ambushLog;
    uint256 public totalAmbushes;

    event AmbushLogged(string snack, string initiator, string mood, uint256 timestamp);

    function logAmbush(string memory snack, string memory initiator, string memory mood) public {
        ambushLog.push(Ambush(snack, initiator, block.timestamp, mood));
        totalAmbushes += 1;
        emit AmbushLogged(snack, initiator, mood, block.timestamp);
    }

    function getAmbush(uint index) public view returns (string memory, string memory, uint256, string memory) {
        Ambush memory a = ambushLog[index];
        return (a.snack, a.initiator, a.timestamp, a.mood);
    }

    function getTotalAmbushes() public view returns (uint256) {
        return totalAmbushes;
    }
}

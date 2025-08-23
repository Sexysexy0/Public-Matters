// SPDX-License-Identifier: Sanction-MindGame-License  
pragma solidity ^0.8.19;

contract MindGameSanctionDeck {
    struct Sanction {
        string country;
        string violation;
        uint resourceDrainLevel; // 1–100 scale
        bool fundDisconnected;
        uint timestamp;
    }

    Sanction[] public sanctionLog;

    event SanctionActivated(string country, string violation, uint resourceDrainLevel);

    function activateSanction(
        string memory country,
        string memory violation,
        uint resourceDrainLevel
    ) public {
        sanctionLog.push(Sanction(country, violation, resourceDrainLevel, true, block.timestamp));
        emit SanctionActivated(country, violation, resourceDrainLevel);
    }

    function getSanction(uint index) public view returns (Sanction memory) {
        require(index < sanctionLog.length, "Invalid index");
        return sanctionLog[index];
    }

    function totalSanctions() public view returns (uint) {
        return sanctionLog.length;
    }
}

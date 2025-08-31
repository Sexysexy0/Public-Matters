// SPDX-License-Identifier: Mythic
pragma solidity ^0.8.19;

contract EnergyAPR {
    struct EnergyLog {
        string source; // e.g., "Nuclear", "Solar", "Battery"
        uint256 energyDrawn; // in kWh
        uint256 emotionalYield; // scale 0–100
        uint256 timestamp;
    }

    EnergyLog[] public logs;

    event EnergyLogged(string source, uint256 energyDrawn, uint256 emotionalYield);

    function logEnergy(string memory source, uint256 drawn, uint256 yield) public {
        logs.push(EnergyLog(source, drawn, yield, block.timestamp));
        emit EnergyLogged(source, drawn, yield);
    }

    function getLog(uint index) public view returns (string memory, uint256, uint256, uint256) {
        EnergyLog memory e = logs[index];
        return (e.source, e.energyDrawn, e.emotionalYield, e.timestamp);
    }
}

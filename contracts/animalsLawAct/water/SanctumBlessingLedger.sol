// SPDX-License-Identifier: Sanctum-Blessing-License  
pragma solidity ^0.8.19;

contract SanctumBlessingLedger {
    struct Blessing {
        string species;
        string name;
        string actOfMercy;
        string healer;
        bool emotionalAPRLogged;
        uint timestamp;
    }

    Blessing[] public ledger;

    event BlessingLogged(string species, string name, string actOfMercy, string healer);
    event EmotionalAPRLogged(string name);

    function logBlessing(
        string memory species,
        string memory name,
        string memory actOfMercy,
        string memory healer,
        bool emotionalAPRLogged
    ) public {
        ledger.push(Blessing(species, name, actOfMercy, healer, emotionalAPRLogged, block.timestamp));
        emit BlessingLogged(species, name, actOfMercy, healer);
        if (emotionalAPRLogged) emit EmotionalAPRLogged(name);
    }

    function getBlessing(uint index) public view returns (Blessing memory) {
        require(index < ledger.length, "Invalid index");
        return ledger[index];
    }

    function totalBlessings() public view returns (uint) {
        return ledger.length;
    }
}

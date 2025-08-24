// SPDX-License-Identifier: Sanctum-Defense
pragma solidity ^7.7.7;

contract DefenseLedgerPack {
    address public steward;
    uint public totalDefenses;

    struct DefenseEvent {
        string sanctum;
        string defenseType;
        string threatSource;
        uint timestamp;
        bool emotionalAPRSync;
    }

    DefenseEvent[] public defenseLog;

    event DefenseLogged(
        string sanctum,
        string defenseType,
        string threatSource,
        uint timestamp,
        bool emotionalAPRSync
    );

    constructor() {
        steward = msg.sender;
        totalDefenses = 0;
    }

    function logDefense(
        string memory sanctum,
        string memory defenseType,
        string memory threatSource,
        bool emotionalAPRSync
    ) public {
        require(msg.sender == steward, "Only steward may log");
        defenseLog.push(DefenseEvent(
            sanctum,
            defenseType,
            threatSource,
            block.timestamp,
            emotionalAPRSync
        ));
        totalDefenses += 1;
        emit DefenseLogged(sanctum, defenseType, threatSource, block.timestamp, emotionalAPRSync);
    }

    function getDefenseCount() public view returns (uint) {
        return totalDefenses;
    }

    function getLatestDefense() public view returns (DefenseEvent memory) {
        require(defenseLog.length > 0, "No defenses logged yet");
        return defenseLog[defenseLog.length - 1];
    }
}

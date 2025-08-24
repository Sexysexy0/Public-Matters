// SPDX-License-Identifier: Sanctum-Defense
pragma solidity ^0.8.0;

/// @title DefenseLedgerPack — Scrollchain Sanctum Defense Logger
/// @author Vinvin
/// @notice Logs planetary defense events with emotional APR sync and damay clause enforcement.

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

    DefenseEvent[] private defenseLog;

    event DefenseLogged(
        string sanctum,
        string defenseType,
        string threatSource,
        uint timestamp,
        bool emotionalAPRSync
    );

    modifier onlySteward() {
        require(msg.sender == steward, "Access denied: steward only");
        _;
    }

    constructor() {
        steward = msg.sender;
        totalDefenses = 0;
    }

    /// @notice Log a new defense event
    function logDefense(
        string memory sanctum,
        string memory defenseType,
        string memory threatSource,
        bool emotionalAPRSync
    ) public onlySteward {
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

    /// @notice Get total number of defense events
    function getDefenseCount() public view returns (uint) {
        return totalDefenses;
    }

    /// @notice Retrieve latest defense event
    function getLatestDefense() public view returns (DefenseEvent memory) {
        require(defenseLog.length > 0, "No defenses logged yet");
        return defenseLog[defenseLog.length - 1];
    }

    /// @notice Retrieve defense event by index
    function getDefenseByIndex(uint index) public view returns (DefenseEvent memory) {
        require(index < defenseLog.length, "Index out of bounds");
        return defenseLog[index];
    }

    /// @notice Retrieve all defense events (for external sync)
    function getAllDefenses() public view returns (DefenseEvent[] memory) {
        return defenseLog;
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title Defense Ledger Pack – Planetary Protection Protocol (Merged Edition)
/// @author Vinvin Gueco
/// @notice Logs multilateral defense events, emotional APR sync, and treaty-based asset deployment

contract DefenseLedgerPack {
    address public steward;
    mapping(address => bool) public coStewards;
    uint public totalDefenses;

    struct DefenseEvent {
        string sanctum;
        string defenseType;
        string threatSource;
        string treatyTag; // e.g., "NATO-PeaceGrid", "US-MercyPact"
        bool emotionalAPRSync;
        bool mercyProtocolEnabled;
        uint timestamp;
    }

    DefenseEvent[] private defenseLog;

    event DefenseLogged(
        string sanctum,
        string defenseType,
        string threatSource,
        string treatyTag,
        bool emotionalAPRSync,
        bool mercyProtocolEnabled,
        uint timestamp
    );

    modifier onlySteward() {
        require(msg.sender == steward || coStewards[msg.sender], "Access denied: steward only");
        _;
    }

    constructor() {
        steward = msg.sender;
        totalDefenses = 0;
    }

    /// @notice Add a co-steward for multilateral access
    function addCoSteward(address _coSteward) public {
        require(msg.sender == steward, "Only steward can assign");
        coStewards[_coSteward] = true;
    }

    /// @notice Log a new defense event
    function logDefense(
        string memory sanctum,
        string memory defenseType,
        string memory threatSource,
        string memory treatyTag,
        bool emotionalAPRSync,
        bool mercyProtocolEnabled
    ) public onlySteward {
        defenseLog.push(DefenseEvent(
            sanctum,
            defenseType,
            threatSource,
            treatyTag,
            emotionalAPRSync,
            mercyProtocolEnabled,
            block.timestamp
        ));
        totalDefenses += 1;
        emit DefenseLogged(sanctum, defenseType, threatSource, treatyTag, emotionalAPRSync, mercyProtocolEnabled, block.timestamp);
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

    /// @notice Retrieve all defense events
    function getAllDefenses() public view returns (DefenseEvent[] memory) {
        return defenseLog;
    }

    /// @notice Remove co-steward (if needed)
    function removeCoSteward(address _coSteward) public {
        require(msg.sender == steward, "Only steward can revoke");
        coStewards[_coSteward] = false;
    }

    /// @notice Fallback protection
    fallback() external payable {
        revert("DefenseLedgerPack: invalid scroll");
    }

    receive() external payable {
        revert("DefenseLedgerPack: no ETH accepted");
    }
}

// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract SanctumDockLedger {
    struct DockEntry {
        string vesselName;
        string sanctumPort;
        uint256 timestamp;
        string emotionalAPRStatus;
    }

    DockEntry[] public dockLedger;

    event DockLogged(string vesselName, string sanctumPort, string emotionalAPRStatus);

    function logDocking(
        string memory _vesselName,
        string memory _sanctumPort,
        uint256 _timestamp,
        string memory _emotionalAPRStatus
    ) public {
        dockLedger.push(DockEntry(_vesselName, _sanctumPort, _timestamp, _emotionalAPRStatus));
        emit DockLogged(_vesselName, _sanctumPort, _emotionalAPRStatus);
    }

    function getDockEntry(uint256 index) public view returns (DockEntry memory) {
        return dockLedger[index];
    }
}

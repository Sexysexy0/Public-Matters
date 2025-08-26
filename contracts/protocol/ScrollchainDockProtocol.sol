// SPDX-License-Identifier: MIT
pragma solidity ^0.8.21;

contract ScrollchainDockProtocol {
    struct DockingEvent {
        string vesselName;
        string sanctumPort;
        uint256 arrivalTimestamp;
        bool emotionalAPRVerified;
    }

    DockingEvent[] public dockLog;

    event VesselDocked(string vesselName, string sanctumPort, bool emotionalAPRVerified);

    function dockVessel(
        string memory _vesselName,
        string memory _sanctumPort,
        uint256 _arrivalTimestamp,
        bool _emotionalAPRVerified
    ) public {
        dockLog.push(DockingEvent(_vesselName, _sanctumPort, _arrivalTimestamp, _emotionalAPRVerified));
        emit VesselDocked(_vesselName, _sanctumPort, _emotionalAPRVerified);
    }

    function getDockingEvent(uint256 index) public view returns (DockingEvent memory) {
        return dockLog[index];
    }
}

// SPDX-License-Identifier: ProtocolSanctum
pragma solidity ^0.8.19;

contract ProtocolSanctifierBeacon {
    struct ProtocolSignal {
        address envoyID;
        string envoyName;
        string protocolType; // e.g., "Flag Placement", "Seating Order", "Greeting Custom"
        string sanctumLevel; // e.g., "Tier I", "Multilateral", "Planetary Grace"
        bool beaconActivated;
        string stewardNote;
    }

    mapping(address => ProtocolSignal) public protocolRegistry;

    event ProtocolTagged(address envoyID, string protocolType);
    event BeaconActivated(address envoyID);

    function tagProtocol(address envoyID, string memory envoyName, string memory protocolType, string memory sanctumLevel, bool beaconActivated, string memory stewardNote) public {
        protocolRegistry[envoyID] = ProtocolSignal(envoyID, envoyName, protocolType, sanctumLevel, beaconActivated, stewardNote);
        emit ProtocolTagged(envoyID, protocolType);
    }

    function activateBeacon(address envoyID) public {
        require(bytes(protocolRegistry[envoyID].envoyName).length > 0, "Protocol not tagged");
        protocolRegistry[envoyID].beaconActivated = true;
        emit BeaconActivated(envoyID);
    }

    function getProtocolStatus(address envoyID) public view returns (ProtocolSignal memory) {
        return protocolRegistry[envoyID];
    }
}

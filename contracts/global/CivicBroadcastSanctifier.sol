// SPDX-License-Identifier: CivicSignalSanctum
pragma solidity ^0.8.19;

contract CivicBroadcastSanctifier {
    struct Broadcast {
        string signalID;
        string originAgency;
        string civicPurpose;
        bool verified;
        string stewardNote;
    }

    mapping(string => Broadcast) public broadcastRegistry;

    event BroadcastTagged(string signalID, string civicPurpose);
    event BroadcastSanctified(string signalID);

    function tagBroadcast(string memory signalID, string memory originAgency, string memory civicPurpose, string memory stewardNote) public {
        broadcastRegistry[signalID] = Broadcast(signalID, originAgency, civicPurpose, false, stewardNote);
        emit BroadcastTagged(signalID, civicPurpose);
    }

    function sanctifyBroadcast(string memory signalID) public {
        require(bytes(broadcastRegistry[signalID].originAgency).length > 0, "Origin not tagged");
        broadcastRegistry[signalID].verified = true;
        emit BroadcastSanctified(signalID);
    }

    function getBroadcastStatus(string memory signalID) public view returns (Broadcast memory) {
        return broadcastRegistry[signalID];
    }
}

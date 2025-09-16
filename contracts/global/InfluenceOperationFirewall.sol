// SPDX-License-Identifier: IOFirewallSanctum
pragma solidity ^0.8.19;

contract InfluenceOperationFirewall {
    struct InfluenceSignal {
        string signalID;
        string originActor;
        string platform;
        bool isCoordinated;
        bool firewallActivated;
        string stewardNote;
    }

    mapping(string => InfluenceSignal) public ioRegistry;

    event SignalTagged(string signalID, string platform);
    event FirewallActivated(string signalID);

    function tagSignal(string memory signalID, string memory originActor, string memory platform, bool isCoordinated, string memory stewardNote) public {
        ioRegistry[signalID] = InfluenceSignal(signalID, originActor, platform, isCoordinated, false, stewardNote);
        emit SignalTagged(signalID, platform);
    }

    function activateFirewall(string memory signalID) public {
        require(ioRegistry[signalID].isCoordinated, "Signal not marked as coordinated");
        ioRegistry[signalID].firewallActivated = true;
        emit FirewallActivated(signalID);
    }

    function getSignalStatus(string memory signalID) public view returns (InfluenceSignal memory) {
        return ioRegistry[signalID];
    }
}

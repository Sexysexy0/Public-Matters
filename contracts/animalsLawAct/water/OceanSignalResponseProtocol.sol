// SPDX-License-Identifier: Ocean-Signal-License  
pragma solidity ^0.8.19;

contract OceanSignalResponseProtocol {
    struct Signal {
        string species;
        string location;
        string distressType;
        bool responded;
        uint timestamp;
    }

    Signal[] public signalLog;

    event SignalReceived(string species, string location, string distressType);
    event ResponseDispatched(string species, string location);

    function receiveSignal(
        string memory species,
        string memory location,
        string memory distressType
    ) public {
        signalLog.push(Signal(species, location, distressType, false, block.timestamp));
        emit SignalReceived(species, location, distressType);
    }

    function dispatchResponse(uint index) public {
        require(index < signalLog.length, "Invalid index");
        signalLog[index].responded = true;
        emit ResponseDispatched(signalLog[index].species, signalLog[index].location);
    }

    function getSignal(uint index) public view returns (Signal memory) {
        require(index < signalLog.length, "Invalid index");
        return signalLog[index];
    }

    function totalSignals() public view returns (uint) {
        return signalLog.length;
    }
}

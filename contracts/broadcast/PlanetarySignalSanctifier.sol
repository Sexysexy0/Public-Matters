// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract PlanetarySignalSanctifier {
    struct Signal {
        string origin;
        string signalType;
        string messageSummary;
        uint256 timestamp;
        bool verified;
        string resonanceTag;
    }

    mapping(uint256 => Signal) public signalLedger;
    uint256 public signalCount;

    event SignalSanctified(uint256 id, string origin, string signalType);

    function logSignal(
        string memory origin,
        string memory signalType,
        string memory messageSummary,
        uint256 timestamp,
        string memory resonanceTag
    ) public {
        signalLedger[signalCount] = Signal(
            origin,
            signalType,
            messageSummary,
            timestamp,
            false,
            resonanceTag
        );
        emit SignalSanctified(signalCount, origin, signalType);
        signalCount++;
    }

    function verifySignal(uint256 id) public {
        signalLedger[id].verified = true;
    }

    function getSignal(uint256 id) public view returns (Signal memory) {
        return signalLedger[id];
    }
}

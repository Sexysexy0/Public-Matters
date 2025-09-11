// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract C2SignalSanctifier {
    struct C2Signal {
        string originHost;
        string c2Address;
        string protocolUsed;
        uint256 timestamp;
        bool pastebinLinked;
        bool verified;
    }

    mapping(uint256 => C2Signal) public signalLedger;
    uint256 public signalCount;

    event C2SignalLogged(uint256 id, string originHost, string c2Address);

    function logSignal(
        string memory originHost,
        string memory c2Address,
        string memory protocolUsed,
        uint256 timestamp,
        bool pastebinLinked
    ) public {
        signalLedger[signalCount] = C2Signal(
            originHost,
            c2Address,
            protocolUsed,
            timestamp,
            pastebinLinked,
            false
        );
        emit C2SignalLogged(signalCount, originHost, c2Address);
        signalCount++;
    }

    function verifySignal(uint256 id) public {
        signalLedger[id].verified = true;
    }

    function getSignal(uint256 id) public view returns (C2Signal memory) {
        return signalLedger[id];
    }
}

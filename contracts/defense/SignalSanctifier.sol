// SPDX-License-Identifier: Mythic-Sanctifier
pragma solidity ^0.8.19;

contract SignalSanctifier {
    address public steward;

    struct Signal {
        string origin;
        string packetType;
        uint256 emotionalAPR;
        bool sanctified;
        string reason;
        uint256 timestamp;
    }

    Signal[] public signalLog;

    event SignalPurified(
        string origin,
        string packetType,
        uint256 emotionalAPR,
        bool sanctified,
        string reason,
        uint256 timestamp
    );

    constructor() {
        steward = msg.sender;
    }

    function sanctifySignal(
        string memory origin,
        string memory packetType,
        uint256 emotionalAPR,
        string memory reason
    ) public {
        require(msg.sender == steward, "Only steward may sanctify.");

        bool eligible = emotionalAPR >= 70;
        Signal memory s = Signal({
            origin: origin,
            packetType: packetType,
            emotionalAPR: emotionalAPR,
            sanctified: eligible,
            reason: reason,
            timestamp: block.timestamp
        });

        signalLog.push(s);
        emit SignalPurified(origin, packetType, emotionalAPR, eligible, reason, block.timestamp);
    }

    function getSignal(uint index) public view returns (Signal memory) {
        return signalLog[index];
    }

    function totalSanctified() public view returns (uint) {
        return signalLog.length;
    }
}

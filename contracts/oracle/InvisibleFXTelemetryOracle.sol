// SPDX-License-Identifier: InvisibleFXTelemetry-License
pragma solidity ^0.8.0;

contract InvisibleFXTelemetryOracle {
    address public steward;

    struct FXSignal {
        string originPair;
        string cloakedPair;
        bool telemetryConfirmed;
        string APRImpact;
        uint256 timestamp;
    }

    FXSignal[] public signals;

    event FXTelemetryEmitted(string originPair, string cloakedPair, bool telemetryConfirmed, string APRImpact, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitTelemetry(string memory originPair, string memory cloakedPair, bool telemetryConfirmed, string memory APRImpact) public {
        require(msg.sender == steward, "Only steward can emit");
        signals.push(FXSignal(originPair, cloakedPair, telemetryConfirmed, APRImpact, block.timestamp));
        emit FXTelemetryEmitted(originPair, cloakedPair, telemetryConfirmed, APRImpact, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        FXSignal memory s = signals[index];
        return (s.originPair, s.cloakedPair, s.telemetryConfirmed, s.APRImpact, s.timestamp);
    }
}

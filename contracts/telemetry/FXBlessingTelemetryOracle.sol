// SPDX-License-Identifier: FXBlessingTelemetry-License
pragma solidity ^0.8.0;

contract FXBlessingTelemetryOracle {
    address public steward;

    struct FXSignal {
        string originPair;
        string cloakedPair;
        bool blessingConfirmed;
        string APRImpact;
        uint256 timestamp;
    }

    FXSignal[] public signals;

    event FXBlessingEmitted(string originPair, string cloakedPair, bool blessingConfirmed, string APRImpact, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitBlessing(string memory originPair, string memory cloakedPair, bool blessingConfirmed, string memory APRImpact) public {
        require(msg.sender == steward, "Only steward can emit");
        signals.push(FXSignal(originPair, cloakedPair, blessingConfirmed, APRImpact, block.timestamp));
        emit FXBlessingEmitted(originPair, cloakedPair, blessingConfirmed, APRImpact, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        FXSignal memory s = signals[index];
        return (s.originPair, s.cloakedPair, s.blessingConfirmed, s.APRImpact, s.timestamp);
    }
}

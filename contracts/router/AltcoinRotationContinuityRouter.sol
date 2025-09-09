// SPDX-License-Identifier: AltcoinRotationContinuity-License
pragma solidity ^0.8.0;

contract AltcoinRotationContinuityRouter {
    address public steward;

    struct RotationSignal {
        string assetFrom;
        string assetTo;
        bool rotationConfirmed;
        string reason;
        uint256 timestamp;
    }

    RotationSignal[] public signals;

    event RotationRouted(string assetFrom, string assetTo, bool rotationConfirmed, string reason, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeRotation(string memory assetFrom, string memory assetTo, bool rotationConfirmed, string memory reason) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(RotationSignal(assetFrom, assetTo, rotationConfirmed, reason, block.timestamp));
        emit RotationRouted(assetFrom, assetTo, rotationConfirmed, reason, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        RotationSignal memory s = signals[index];
        return (s.assetFrom, s.assetTo, s.rotationConfirmed, s.reason, s.timestamp);
    }
}

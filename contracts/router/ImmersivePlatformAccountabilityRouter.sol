// SPDX-License-Identifier: ImmersivePlatformAccountability-License
pragma solidity ^0.8.0;

contract ImmersivePlatformAccountabilityRouter {
    address public steward;

    struct AccountabilitySignal {
        string platformID;
        string riskVector;
        bool violationConfirmed;
        string signalType;
        uint256 timestamp;
    }

    AccountabilitySignal[] public signals;

    event AccountabilityRouted(string platformID, string riskVector, bool violationConfirmed, string signalType, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeSignal(string memory platformID, string memory riskVector, bool violationConfirmed, string memory signalType) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(AccountabilitySignal(platformID, riskVector, violationConfirmed, signalType, block.timestamp));
        emit AccountabilityRouted(platformID, riskVector, violationConfirmed, signalType, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        AccountabilitySignal memory s = signals[index];
        return (s.platformID, s.riskVector, s.violationConfirmed, s.signalType, s.timestamp);
    }
}

// SPDX-License-Identifier: SanctumCollapseTelemetry-License
pragma solidity ^0.8.0;

contract SanctumCollapseTelemetryOracle {
    address public steward;

    struct CollapseSignal {
        string collapseID;
        string originSanctum;
        bool collapseConfirmed;
        string breachType;
        uint256 timestamp;
    }

    CollapseSignal[] public signals;

    event CollapseEmitted(string collapseID, string originSanctum, bool collapseConfirmed, string breachType, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitCollapse(string memory collapseID, string memory originSanctum, bool collapseConfirmed, string memory breachType) public {
        require(msg.sender == steward, "Only steward can emit");
        signals.push(CollapseSignal(collapseID, originSanctum, collapseConfirmed, breachType, block.timestamp));
        emit CollapseEmitted(collapseID, originSanctum, collapseConfirmed, breachType, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        CollapseSignal memory s = signals[index];
        return (s.collapseID, s.originSanctum, s.collapseConfirmed, s.breachType, s.timestamp);
    }
}

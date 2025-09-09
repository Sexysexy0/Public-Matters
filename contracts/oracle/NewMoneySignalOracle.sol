// SPDX-License-Identifier: NewMoneySignalOracle-License
pragma solidity ^0.8.0;

contract NewMoneySignalOracle {
    address public steward;

    struct MoneySignal {
        string asset;
        string originEntity;
        uint256 inflowAmount;
        bool repricingTriggered;
        uint256 timestamp;
    }

    MoneySignal[] public signals;

    event SignalEmitted(string asset, string originEntity, uint256 inflowAmount, bool repricingTriggered, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitSignal(string memory asset, string memory originEntity, uint256 inflowAmount, bool repricingTriggered) public {
        require(msg.sender == steward, "Only steward can emit");
        signals.push(MoneySignal(asset, originEntity, inflowAmount, repricingTriggered, block.timestamp));
        emit SignalEmitted(asset, originEntity, inflowAmount, repricingTriggered, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, uint256, bool, uint256) {
        MoneySignal memory s = signals[index];
        return (s.asset, s.originEntity, s.inflowAmount, s.repricingTriggered, s.timestamp);
    }
}

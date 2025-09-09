// SPDX-License-Identifier: EnergyRemittanceSignal-License
pragma solidity ^0.8.0;

contract EnergyRemittanceSignalOracle {
    address public steward;

    struct RemittanceSignal {
        string currency;
        string energyType;
        bool signalConfirmed;
        string region;
        uint256 timestamp;
    }

    RemittanceSignal[] public signals;

    event RemittanceSignalEmitted(string currency, string energyType, bool signalConfirmed, string region, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitSignal(string memory currency, string memory energyType, bool signalConfirmed, string memory region) public {
        require(msg.sender == steward, "Only steward can emit");
        signals.push(RemittanceSignal(currency, energyType, signalConfirmed, region, block.timestamp));
        emit RemittanceSignalEmitted(currency, energyType, signalConfirmed, region, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        RemittanceSignal memory s = signals[index];
        return (s.currency, s.energyType, s.signalConfirmed, s.region, s.timestamp);
    }
}

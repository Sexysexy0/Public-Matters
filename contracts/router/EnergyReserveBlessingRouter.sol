// SPDX-License-Identifier: EnergyReserveBlessing-License
pragma solidity ^0.8.0;

contract EnergyReserveBlessingRouter {
    address public steward;

    struct BlessingSignal {
        string currency;
        string energyType;
        bool blessingConfirmed;
        uint256 timestamp;
    }

    BlessingSignal[] public signals;

    event EnergyBlessingRouted(string currency, string energyType, bool blessingConfirmed, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function routeBlessing(string memory currency, string memory energyType, bool blessingConfirmed) public {
        require(msg.sender == steward, "Only steward can route");
        signals.push(BlessingSignal(currency, energyType, blessingConfirmed, block.timestamp));
        emit EnergyBlessingRouted(currency, energyType, blessingConfirmed, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, uint256) {
        BlessingSignal memory s = signals[index];
        return (s.currency, s.energyType, s.blessingConfirmed, s.timestamp);
    }
}

// SPDX-License-Identifier: EnergyFXSignal-License
pragma solidity ^0.8.0;

contract EnergyFXSignalOracle {
    address public steward;

    struct FXSignal {
        string currency;
        string energyType;
        bool signalConfirmed;
        string clauseType;
        uint256 timestamp;
    }

    FXSignal[] public signals;

    event EnergyFXSignalEmitted(string currency, string energyType, bool signalConfirmed, string clauseType, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function emitSignal(string memory currency, string memory energyType, bool signalConfirmed, string memory clauseType) public {
        require(msg.sender == steward, "Only steward can emit");
        signals.push(FXSignal(currency, energyType, signalConfirmed, clauseType, block.timestamp));
        emit EnergyFXSignalEmitted(currency, energyType, signalConfirmed, clauseType, block.timestamp);
    }

    function getSignal(uint index) public view returns (string memory, string memory, bool, string memory, uint256) {
        FXSignal memory s = signals[index];
        return (s.currency, s.energyType, s.signalConfirmed, s.clauseType, s.timestamp);
    }
}

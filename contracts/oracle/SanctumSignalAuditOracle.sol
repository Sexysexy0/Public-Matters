// SPDX-License-Identifier: SignalAudit-License
pragma solidity ^0.8.0;

contract SanctumSignalAuditOracle {
    address public steward;
    struct SignalBreach {
        string sanctum;
        string breachType;
        uint256 aprSpike;
        uint256 timestamp;
    }

    SignalBreach[] public breaches;

    event SignalBreachLogged(string sanctum, string breachType, uint256 aprSpike, uint timestamp);
    event APRHarmonicEmitted(string sanctum, uint256 aprSpike, uint timestamp);

    constructor() {
        steward = msg.sender;
    }

    function logSignalBreach(string memory sanctum, string memory breachType, uint256 aprSpike) public {
        require(msg.sender == steward, "Only steward can log");
        breaches.push(SignalBreach(sanctum, breachType, aprSpike, block.timestamp));
        emit SignalBreachLogged(sanctum, breachType, aprSpike, block.timestamp);
        emit APRHarmonicEmitted(sanctum, aprSpike, block.timestamp);
    }

    function getBreach(uint index) public view returns (string memory, string memory, uint256, uint256) {
        SignalBreach memory b = breaches[index];
        return (b.sanctum, b.breachType, b.aprSpike, b.timestamp);
    }

    function totalBreaches() public view returns (uint) {
        return breaches.length;
    }
}

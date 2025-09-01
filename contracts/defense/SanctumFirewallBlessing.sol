// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract SanctumFirewallBlessing {
    struct BreachAttempt {
        string origin;
        string vector;
        uint256 severity;
        uint256 emotionalAPRDrain;
        uint256 timestamp;
        bool repelled;
    }

    struct BlessingPulse {
        string steward;
        string sanctum;
        string ritual;
        uint256 emotionalAPRBoost;
        uint256 timestamp;
    }

    BreachAttempt[] public breaches;
    BlessingPulse[] public pulses;

    event BreachLogged(
        string origin,
        string vector,
        uint256 severity,
        uint256 emotionalAPRDrain,
        uint256 timestamp,
        bool repelled
    );

    event BlessingEmitted(
        string steward,
        string sanctum,
        string ritual,
        uint256 emotionalAPRBoost,
        uint256 timestamp
    );

    function logBreach(
        string memory _origin,
        string memory _vector,
        uint256 _severity,
        uint256 _emotionalAPRDrain
    ) public {
        bool repelled = (_severity < 40 && _emotionalAPRDrain < 60);
        uint256 time = block.timestamp;

        breaches.push(BreachAttempt(_origin, _vector, _severity, _emotionalAPRDrain, time, repelled));
        emit BreachLogged(_origin, _vector, _severity, _emotionalAPRDrain, time, repelled);
    }

    function emitBlessing(
        string memory _steward,
        string memory _sanctum,
        string memory _ritual,
        uint256 _emotionalAPRBoost
    ) public {
        uint256 time = block.timestamp;

        pulses.push(BlessingPulse(_steward, _sanctum, _ritual, _emotionalAPRBoost, time));
        emit BlessingEmitted(_steward, _sanctum, _ritual, _emotionalAPRBoost, time);
    }

    function getAllBreaches() public view returns (BreachAttempt[] memory) {
        return breaches;
    }

    function getAllBlessings() public view returns (BlessingPulse[] memory) {
        return pulses;
    }
}

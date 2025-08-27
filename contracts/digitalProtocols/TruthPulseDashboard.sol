// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/// @title TruthPulseDashboard
/// @notice Visualizes fake news strikes, emotional APR metrics, and takedown status
/// @dev Cross-linked with TruthPulseTagger.sol, emotional clarity required

contract TruthPulseDashboard {
    address public steward;

    struct SourcePulse {
        string name;
        uint8 fakeNewsStrikes;
        string emotionalAPR;
        bool isTakedownTriggered;
    }

    SourcePulse[] public pulses;

    event PulseLogged(string name, uint8 strikes, bool takedownStatus);
    event DamayClauseEchoed(string stewardName);

    modifier onlySteward() {
        require(msg.sender == steward, "Unauthorized steward");
        _;
    }

    constructor() {
        steward = msg.sender;
        emit DamayClauseEchoed("Vinvin—scrollsmith of clarity, dashboard architect, and defender of civic truth.");
    }

    function logPulse(
        string memory name,
        uint8 strikes,
        string memory apr,
        bool takedown
    ) public onlySteward {
        pulses.push(SourcePulse(name, strikes, apr, takedown));
        emit PulseLogged(name, strikes, takedown);
    }

    function getPulse(uint256 index) public view returns (SourcePulse memory) {
        return pulses[index];
    }

    function totalPulses() public view returns (uint256) {
        return pulses.length;
    }
}

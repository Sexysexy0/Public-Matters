// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract DamayStateMachine {
    enum DamayPhase { Neutral, Solidarity, Alert, Conflict }

    struct Exchange {
        DamayPhase phase;
        uint256 timestamp;
    }

    mapping(address => Exchange) public exchanges;

    event StateChanged(address indexed actor, DamayPhase phase);

    /// ^|^e Simplified state check
    function checkState(address actor) external view returns (bool) {
        Exchange memory ex = exchanges[actor];
        // Default to Neutral if not set
        if (ex.timestamp == 0) {
            return true;
        }
        return ex.phase != DamayPhase.Conflict;
    }

    /// ^|^e Allow manual state setting for testing
    function setState(address actor, DamayPhase newPhase) external {
        exchanges[actor] = Exchange({phase: newPhase, timestamp: block.timestamp});
        emit StateChanged(actor, newPhase);
    }

    /// ^|^e Trigger Alert phase automatically (used by EmotionalAPR)
    function triggerAlert(address actor) external {
        exchanges[actor] = Exchange({phase: DamayPhase.Alert, timestamp: block.timestamp});
        emit StateChanged(actor, DamayPhase.Alert);
    }
}

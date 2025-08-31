// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.19;

/// @title PlanetaryOverrideSuite
/// @author Vinvin
/// @notice Auto-locks rogue sanctums, logs breaches, and triggers override rituals

contract PlanetaryOverrideSuite {
    struct BreachLog {
        string actor;
        string reason;
        uint timestamp;
        bool overrideTriggered;
    }

    mapping(string => BreachLog) public breachRecords;
    string[] public rogueActors;

    event BreachDetected(string actor, string reason);
    event OverrideActivated(string actor);
    event SanctumLocked(string actor);

    /// @notice Trigger override if rogue behavior is detected
    function triggerOverride(string memory _actor, string memory _reason) public {
        breachRecords[_actor] = BreachLog(_actor, _reason, block.timestamp, true);
        rogueActors.push(_actor);

        emit BreachDetected(_actor, _reason);
        emit OverrideActivated(_actor);
        emit SanctumLocked(_actor);
    }

    /// @notice Get all rogue actors
    function getRogueActors() public view returns (string[] memory) {
        return rogueActors;
    }

    /// @notice Check if override was triggered
    function isOverrideTriggered(string memory _actor) public view returns (bool) {
        return breachRecords[_actor].overrideTriggered;
    }

    /// @notice Retrieve breach log
    function getBreachLog(string memory _actor) public view returns (
        string memory reason, uint timestamp, bool overrideTriggered
    ) {
        BreachLog memory log = breachRecords[_actor];
        return (log.reason, log.timestamp, log.overrideTriggered);
    }
}

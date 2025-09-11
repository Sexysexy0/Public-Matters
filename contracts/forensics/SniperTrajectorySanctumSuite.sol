// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract SniperTrajectorySanctumSuite {
    struct TrajectoryLog {
        string location;
        uint256 angleDegrees;
        uint256 distanceYards;
        uint256 timestamp;
        string escapeRoute;
        bool confirmed;
    }

    mapping(uint256 => TrajectoryLog) public ballisticLedger;
    uint256 public logCount;

    event TrajectoryLogged(uint256 id, string location, string escapeRoute);

    function logTrajectory(
        string memory location,
        uint256 angleDegrees,
        uint256 distanceYards,
        uint256 timestamp,
        string memory escapeRoute
    ) public {
        ballisticLedger[logCount] = TrajectoryLog(
            location,
            angleDegrees,
            distanceYards,
            timestamp,
            escapeRoute,
            false
        );
        emit TrajectoryLogged(logCount, location, escapeRoute);
        logCount++;
    }

    function confirmTrajectory(uint256 id) public {
        ballisticLedger[id].confirmed = true;
    }

    function getTrajectory(uint256 id) public view returns (TrajectoryLog memory) {
        return ballisticLedger[id];
    }
}

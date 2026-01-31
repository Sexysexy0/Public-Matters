// AbsenceNeutralityProtocol.sol
pragma solidity ^0.8.0;

contract AbsenceNeutralityProtocol {
    mapping(address => uint256) public weeklyAbsences;
    event AbsenceRecorded(address indexed worker, uint256 count);
    event Encouragement(address indexed worker, string message);

    // Record absence
    function recordAbsence(address worker) public {
        weeklyAbsences[worker] += 1;
        emit AbsenceRecorded(worker, weeklyAbsences[worker]);

        // If 2 absences in a week, issue verbal encouragement only
        if (weeklyAbsences[worker] == 2) {
            emit Encouragement(worker, "We value you, please take care.");
        }
    }

    // Reset weekly absences (e.g., every Monday)
    function resetWeek(address worker) public {
        weeklyAbsences[worker] = 0;
    }
}

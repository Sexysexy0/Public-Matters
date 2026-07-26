// CompassionateWorkProtocol.sol
pragma solidity ^0.8.0;

contract CompassionateWorkProtocol {
    mapping(address => uint256) public workloadLevel;
    mapping(address => uint256) public weeklyAttendance;
    mapping(address => bool) public overloadFlag;

    event WorkRecorded(address indexed worker, uint256 workload);
    event AbsenceAllowed(address indexed worker, string message);
    event EmployerCharacter(string traits);
    event IncentiveGranted(address indexed worker, string reward);

    // Record workload and flag heavy positions
    function recordWork(address worker, uint256 workload) public {
        workloadLevel[worker] = workload;
        emit WorkRecorded(worker, workload);

        if (workload > 8) { // threshold for heavy work
            overloadFlag[worker] = true;
            emit AbsenceAllowed(worker, "Heavy workload detected, absence allowed without penalty.");
        } else {
            overloadFlag[worker] = false;
        }
    }

    // Record attendance
    function recordAttendance(address worker) public {
        weeklyAttendance[worker] += 1;
    }

    // Grant reward for weekly attendance + teamwork
    function grantReward(address worker) public {
        if (weeklyAttendance[worker] >= 5) {
            emit IncentiveGranted(worker, "Weekly attendance complete: reward granted.");
        }
    }

    // Employer character arc
    function declareEmployerTraits() public {
        emit EmployerCharacter("Mabait, mahinahon, madaling kausap, maaasahan, nakikipagkwentuhan, nakikipagkakaisa");
    }
}

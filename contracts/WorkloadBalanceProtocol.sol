// WorkloadBalanceProtocol.sol
pragma solidity ^0.8.0;

contract WorkloadBalanceProtocol {
    mapping(address => uint256) public dailyWorkload;
    mapping(address => uint256) public weeklyAttendance;
    mapping(address => bool) public overloadFlag;

    event WorkloadRecorded(address indexed worker, uint256 workload);
    event OverloadDetected(address indexed worker, string message);
    event IncentiveGranted(address indexed worker, uint256 reward);

    // Record daily workload
    function recordWorkload(address worker, uint256 workload) public {
        dailyWorkload[worker] = workload;
        emit WorkloadRecorded(worker, workload);

        if (workload > 8) { // example threshold
            overloadFlag[worker] = true;
            emit OverloadDetected(worker, "Workload heavy, redistribute tasks.");
        } else {
            overloadFlag[worker] = false;
        }
    }

    // Record attendance
    function recordAttendance(address worker) public {
        weeklyAttendance[worker] += 1;
    }

    // Reward if complete attendance (5 days)
    function grantIncentive(address worker) public {
        if (weeklyAttendance[worker] >= 5) {
            emit IncentiveGranted(worker, 100); // example reward points
        }
    }

    // Reset weekly attendance
    function resetWeek(address worker) public {
        weeklyAttendance[worker] = 0;
    }
}

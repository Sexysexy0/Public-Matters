// WorkerRightsProtocol.sol
pragma solidity ^0.8.0;

contract WorkerRightsProtocol {
    // --- Breaktime Autonomy ---
    mapping(address => uint256) public totalBreaktime;
    mapping(address => uint256[]) public breakSegments;
    uint256 public constant MIN_BREAKTIME = 120; // 2 hours minimum

    event BreakScheduled(address indexed worker, uint256 duration);

    function scheduleBreak(address worker, uint256 duration) public {
        totalBreaktime[worker] += duration;
        breakSegments[worker].push(duration);
        emit BreakScheduled(worker, duration);
    }

    function hasMetBreakRequirement(address worker) public view returns (bool) {
        return totalBreaktime[worker] >= MIN_BREAKTIME;
    }

    // --- Absence Neutrality ---
    mapping(address => uint256) public weeklyAbsences;
    event AbsenceRecorded(address indexed worker, uint256 count);
    event Encouragement(address indexed worker, string message);

    function recordAbsence(address worker) public {
        weeklyAbsences[worker] += 1;
        emit AbsenceRecorded(worker, weeklyAbsences[worker]);

        if (weeklyAbsences[worker] == 2) {
            emit Encouragement(worker, "We value you, please take care.");
        }
    }

    function resetWeek(address worker) public {
        weeklyAbsences[worker] = 0;
    }

    // --- Calm Leadership Arc ---
    event PositiveFeedback(address indexed manager, address indexed worker, string message);

    function giveFeedback(address manager, address worker, string memory message) public {
        emit PositiveFeedback(manager, worker, message);
    }
}

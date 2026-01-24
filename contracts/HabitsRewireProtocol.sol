pragma solidity ^0.8.20;

contract HabitsRewireProtocol {
    address public admin;

    struct Habit {
        string action;       // e.g. daily reading, journaling, exercise
        string purpose;      // e.g. skill growth, health, focus
        string status;       // e.g. planned, ongoing, completed
        uint256 timestamp;
    }

    Habit[] public habits;

    event HabitLogged(string action, string purpose, string status, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logHabit(string calldata action, string calldata purpose, string calldata status) external onlyAdmin {
        habits.push(Habit(action, purpose, status, block.timestamp));
        emit HabitLogged(action, purpose, status, block.timestamp);
    }

    function totalHabits() external view returns (uint256) {
        return habits.length;
    }
}

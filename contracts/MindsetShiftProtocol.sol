pragma solidity ^0.8.20;

contract MindsetShiftProtocol {
    address public admin;

    struct Shift {
        string training;     // e.g. financial literacy, growth mindset, resilience coaching
        string goal;         // e.g. escape paycheck-to-paycheck, embrace learning
        string outcome;      // e.g. empowered, disciplined, future-ready
        uint256 timestamp;
    }

    Shift[] public shifts;

    event ShiftLogged(string training, string goal, string outcome, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logShift(string calldata training, string calldata goal, string calldata outcome) external onlyAdmin {
        shifts.push(Shift(training, goal, outcome, block.timestamp));
        emit ShiftLogged(training, goal, outcome, block.timestamp);
    }

    function totalShifts() external view returns (uint256) {
        return shifts.length;
    }
}

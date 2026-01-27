pragma solidity ^0.8.20;

contract EUShiftProtocol {
    address public admin;

    struct Shift {
        string category;     // e.g. BEV, hybrid, petrol/diesel
        string share;        // e.g. 17.4%, 34.5%, 35.5%
        string trend;        // e.g. rising, stable, declining
        uint256 timestamp;
    }

    Shift[] public shifts;

    event ShiftLogged(string category, string share, string trend, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logShift(string calldata category, string calldata share, string calldata trend) external onlyAdmin {
        shifts.push(Shift(category, share, trend, block.timestamp));
        emit ShiftLogged(category, share, trend, block.timestamp);
    }

    function totalShifts() external view returns (uint256) {
        return shifts.length;
    }
}

pragma solidity ^0.8.20;

contract IndustrialShiftProtocol {
    address public admin;

    struct Shift {
        string fromSector;   // e.g. low-end BPO, raw exports
        string toSector;     // e.g. manufacturing, value-added industries
        uint256 timestamp;
    }

    Shift[] public shifts;

    event ShiftLogged(string fromSector, string toSector, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logShift(string calldata fromSector, string calldata toSector) external onlyAdmin {
        shifts.push(Shift(fromSector, toSector, block.timestamp));
        emit ShiftLogged(fromSector, toSector, block.timestamp);
    }

    function totalShifts() external view returns (uint256) {
        return shifts.length;
    }
}

pragma solidity ^0.8.20;

contract DeDollarizationProtocol {
    address public admin;

    struct Shift {
        string actor;        // e.g. BRICS nations
        string method;       // e.g. trade without USD
        string impact;       // e.g. reserve currency decline, economic instability
        uint256 timestamp;
    }

    Shift[] public shifts;

    event ShiftLogged(string actor, string method, string impact, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logShift(string calldata actor, string calldata method, string calldata impact) external onlyAdmin {
        shifts.push(Shift(actor, method, impact, block.timestamp));
        emit ShiftLogged(actor, method, impact, block.timestamp);
    }

    function totalShifts() external view returns (uint256) {
        return shifts.length;
    }
}

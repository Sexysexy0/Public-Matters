pragma solidity ^0.8.20;

contract FeeShiftProtocol {
    address public admin;

    struct Fee {
        string typeOfFee;    // e.g. annual fee, balance transfer fee
        string reason;       // e.g. offset capped interest
        string impact;       // e.g. higher costs for users
        uint256 timestamp;
    }

    Fee[] public fees;

    event FeeLogged(string typeOfFee, string reason, string impact, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logFee(string calldata typeOfFee, string calldata reason, string calldata impact) external onlyAdmin {
        fees.push(Fee(typeOfFee, reason, impact, block.timestamp));
        emit FeeLogged(typeOfFee, reason, impact, block.timestamp);
    }

    function totalFees() external view returns (uint256) {
        return fees.length;
    }
}

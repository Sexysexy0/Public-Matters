pragma solidity ^0.8.20;

contract LivingWageProtocol {
    address public admin;

    struct Wage {
        string region;       // e.g. NCR, Bulacan
        string benchmark;    // e.g. cost of living index
        string rate;         // e.g. proposed living wage
        uint256 timestamp;
    }

    Wage[] public wages;

    event WageLogged(string region, string benchmark, string rate, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logWage(string calldata region, string calldata benchmark, string calldata rate) external onlyAdmin {
        wages.push(Wage(region, benchmark, rate, block.timestamp));
        emit WageLogged(region, benchmark, rate, block.timestamp);
    }

    function totalWages() external view returns (uint256) {
        return wages.length;
    }
}

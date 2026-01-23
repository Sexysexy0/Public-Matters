pragma solidity ^0.8.20;

contract CrossRegionStandardProtocol {
    address public admin;

    struct Standard {
        string job;          // e.g. call center agent
        string regions;      // e.g. NCR + Bulacan
        string wageRate;     // e.g. NCR minimum applied
        uint256 timestamp;
    }

    Standard[] public standards;

    event StandardLogged(string job, string regions, string wageRate, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logStandard(string calldata job, string calldata regions, string calldata wageRate) external onlyAdmin {
        standards.push(Standard(job, regions, wageRate, block.timestamp));
        emit StandardLogged(job, regions, wageRate, block.timestamp);
    }

    function totalStandards() external view returns (uint256) {
        return standards.length;
    }
}

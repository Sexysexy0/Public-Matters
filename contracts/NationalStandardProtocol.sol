pragma solidity ^0.8.20;

contract NationalStandardProtocol {
    address public admin;

    struct Standard {
        string job;          // e.g. factory worker, call center agent
        string unifiedRate;  // e.g. national minimum wage
        string rationale;    // e.g. fairness, equity across regions
        uint256 timestamp;
    }

    Standard[] public standards;

    event StandardLogged(string job, string unifiedRate, string rationale, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logStandard(string calldata job, string calldata unifiedRate, string calldata rationale) external onlyAdmin {
        standards.push(Standard(job, unifiedRate, rationale, block.timestamp));
        emit StandardLogged(job, unifiedRate, rationale, block.timestamp);
    }

    function totalStandards() external view returns (uint256) {
        return standards.length;
    }
}

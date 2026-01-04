pragma solidity ^0.8.20;

contract PublicFundsCommonsProtocol {
    address public admin;

    struct FundLog {
        string project;
        uint256 amount;
        string status;
        uint256 timestamp;
    }

    FundLog[] public logs;

    event FundLogged(string project, uint256 amount, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logFund(string calldata project, uint256 amount, string calldata status) external onlyAdmin {
        logs.push(FundLog(project, amount, status, block.timestamp));
        emit FundLogged(project, amount, status, block.timestamp);
    }

    function totalLogs() external view returns (uint256) {
        return logs.length;
    }
}

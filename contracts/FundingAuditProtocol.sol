pragma solidity ^0.8.20;

contract FundingAuditProtocol {
    address public admin;

    struct Fund {
        string source;       // e.g. government, PPP, international loan
        uint256 amount;      // e.g. 5000000000
        string purpose;      // e.g. retrofit, modernization, safety compliance
        string status;       // e.g. allocated, spent, audited
        uint256 timestamp;
    }

    Fund[] public funds;

    event FundLogged(string source, uint256 amount, string purpose, string status, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logFund(string calldata source, uint256 amount, string calldata purpose, string calldata status) external onlyAdmin {
        funds.push(Fund(source, amount, purpose, status, block.timestamp));
        emit FundLogged(source, amount, purpose, status, block.timestamp);
    }

    function totalFunds() external view returns (uint256) {
        return funds.length;
    }
}

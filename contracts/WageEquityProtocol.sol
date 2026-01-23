pragma solidity ^0.8.20;

contract WageEquityProtocol {
    address public admin;

    struct Equity {
        string region;       // e.g. NCR, Bulacan
        string job;          // e.g. call center, factory
        string rate;         // e.g. standardized NCR wage
        uint256 timestamp;
    }

    Equity[] public equities;

    event EquityLogged(string region, string job, string rate, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logEquity(string calldata region, string calldata job, string calldata rate) external onlyAdmin {
        equities.push(Equity(region, job, rate, block.timestamp));
        emit EquityLogged(region, job, rate, block.timestamp);
    }

    function totalEquities() external view returns (uint256) {
        return equities.length;
    }
}

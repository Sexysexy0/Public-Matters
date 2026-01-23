pragma solidity ^0.8.20;

contract RemoteWorkEquityProtocol {
    address public admin;

    struct Equity {
        string job;          // e.g. NCR-based remote role
        string location;     // e.g. Bulacan
        string wagePolicy;   // e.g. NCR rate applied remotely
        uint256 timestamp;
    }

    Equity[] public equities;

    event EquityLogged(string job, string location, string wagePolicy, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logEquity(string calldata job, string calldata location, string calldata wagePolicy) external onlyAdmin {
        equities.push(Equity(job, location, wagePolicy, block.timestamp));
        emit EquityLogged(job, location, wagePolicy, block.timestamp);
    }

    function totalEquities() external view returns (uint256) {
        return equities.length;
    }
}

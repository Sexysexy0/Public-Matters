pragma solidity ^0.8.20;

contract MacroWealthProtocol {
    address public admin;

    struct Wealth {
        string sector;       // e.g. Crypto, Gold, Stocks
        uint256 value;       // symbolic macro value
        string trend;        // e.g. Growth, Decline
        uint256 timestamp;
    }

    Wealth[] public wealths;

    event WealthLogged(string sector, uint256 value, string trend, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logWealth(string calldata sector, uint256 value, string calldata trend) external onlyAdmin {
        wealths.push(Wealth(sector, value, trend, block.timestamp));
        emit WealthLogged(sector, value, trend, block.timestamp);
    }

    function totalWealthLogs() external view returns (uint256) {
        return wealths.length;
    }
}

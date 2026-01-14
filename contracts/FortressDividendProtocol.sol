pragma solidity ^0.8.20;

contract FortressDividendProtocol {
    address public admin;

    struct Dividend {
        uint256 amount;      // dividend per share
        string status;       // e.g. increased, maintained
        uint256 timestamp;
    }

    Dividend[] public dividends;

    event DividendLogged(uint256 amount, string status, uint256 timestamp);

    constructor() { admin = msg.sender; }

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logDividend(uint256 amount, string calldata status) external onlyAdmin {
        dividends.push(Dividend(amount, status, block.timestamp));
        emit DividendLogged(amount, status, block.timestamp);
    }

    function totalDividends() external view returns (uint256) {
        return dividends.length;
    }
}

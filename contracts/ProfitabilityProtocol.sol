pragma solidity ^0.8.20;

contract ProfitabilityProtocol {
    address public admin;

    struct Profit {
        string company;      // e.g. AI startup, hardware firm
        string status;       // e.g. profit, loss, break-even
        string driver;       // e.g. hardware sales, subscriptions
        uint256 timestamp;
    }

    Profit[] public profits;

    event ProfitLogged(string company, string status, string driver, uint256 timestamp);

    constructor() { admin = msg.sender; }
    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    function logProfit(string calldata company, string calldata status, string calldata driver) external onlyAdmin {
        profits.push(Profit(company, status, driver, block.timestamp));
        emit ProfitLogged(company, status, driver, block.timestamp);
    }

    function totalProfits() external view returns (uint256) {
        return profits.length;
    }
}

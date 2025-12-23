// contracts/FairCredit.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title FairCredit
 * @notice Logs communal access to fair credit and lending practices.
 */
contract FairCredit {
    address public admin;

    struct Credit {
        string borrower;    // "MinimumWageEarner", "Freelancer"
        uint256 amount;
        string status;      // "Approved", "Pending", "Rejected"
        uint256 timestamp;
    }

    Credit[] public credits;

    event CreditLogged(string borrower, uint256 amount, string status, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logCredit(string calldata borrower, uint256 amount, string calldata status) external onlyAdmin {
        credits.push(Credit(borrower, amount, status, block.timestamp));
        emit CreditLogged(borrower, amount, status, block.timestamp);
    }

    function totalCredits() external view returns (uint256) { return credits.length; }

    function getCredit(uint256 id) external view returns (Credit memory) {
        require(id < credits.length, "Invalid id");
        return credits[id];
    }
}

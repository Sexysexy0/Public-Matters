// contracts/WageAudit.sol
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title WageAudit
 * @notice Tracks wage levels and communal equity in pay.
 */
contract WageAudit {
    address public admin;

    struct Wage {
        string sector;      // "Manufacturing", "IT", "Retail"
        uint256 averagePay;
        string verdict;     // "Fair", "Unfair"
        uint256 timestamp;
    }

    Wage[] public wages;

    event WageLogged(string sector, uint256 averagePay, string verdict, uint256 timestamp);

    modifier onlyAdmin() { require(msg.sender == admin, "Not admin"); _; }

    constructor() { admin = msg.sender; }

    function logWage(string calldata sector, uint256 averagePay, string calldata verdict) external onlyAdmin {
        wages.push(Wage(sector, averagePay, verdict, block.timestamp));
        emit WageLogged(sector, averagePay, verdict, block.timestamp);
    }

    function totalWages() external view returns (uint256) { return wages.length; }

    function getWage(uint256 id) external view returns (Wage memory) {
        require(id < wages.length, "Invalid id");
        return wages[id];
    }
}

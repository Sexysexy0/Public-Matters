// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

contract LoanSharkRegistry {
    struct LoanShark {
        string name;
        string location;
        uint256 interestRate;
        string emotionalDamageReport;
        bool isBlacklisted;
    }

    mapping(address => LoanShark) public registry;
    event LoanSharkReported(address indexed shark, string reason);

    function reportLoanShark(
        address shark,
        string memory name,
        string memory location,
        uint256 interestRate,
        string memory emotionalDamageReport
    ) public {
        registry[shark] = LoanShark(name, location, interestRate, emotionalDamageReport, true);
        emit LoanSharkReported(shark, emotionalDamageReport);
    }

    function isBlacklisted(address shark) public view returns (bool) {
        return registry[shark].isBlacklisted;
    }
}

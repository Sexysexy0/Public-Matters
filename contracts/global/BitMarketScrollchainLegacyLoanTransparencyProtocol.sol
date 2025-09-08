// SPDX-License-Identifier: Mythic-License
pragma solidity ^0.8.0;

contract BitMarketScrollchainLegacyLoanTransparencyProtocol {
    address public steward;
    mapping(string => bool) public flaggedEntities;

    event LoanFlagged(string entity, string loanID, string status, uint timestamp);

    function flagLoan(string memory entity, string memory loanID) public {
        flaggedEntities[entity] = true;
        emit LoanFlagged(entity, loanID, "🚨 Legacy Loan Flagged for Severance", block.timestamp);
    }

    function isFlagged(string memory entity) public view returns (bool) {
        return flaggedEntities[entity];
    }
}

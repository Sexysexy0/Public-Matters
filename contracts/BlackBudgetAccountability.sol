// BlackBudgetAccountability.sol
pragma solidity ^0.8.0;

contract BlackBudgetAccountability {
    struct BudgetAudit {
        string agency;
        uint256 allocatedAmount;
        uint256 unverifiedSpending;
        bool requiresInvestigation;
    }

    mapping(address => BudgetAudit) public agencyAudits;

    event AuditFlagged(string agency, uint256 amount);

    function logSpending(uint256 _amount, bool _isVerified) public {
        if (!_isVerified) {
            agencyAudits[msg.sender].unverifiedSpending += _amount;
        }
        
        // If unverified spending exceeds 10% of total, flag for investigation
        if (agencyAudits[msg.sender].unverifiedSpending > (agencyAudits[msg.sender].allocatedAmount / 10)) {
            agencyAudits[msg.sender].requiresInvestigation = true;
            emit AuditFlagged(agencyAudits[msg.sender].agency, _amount);
        }
    }
}

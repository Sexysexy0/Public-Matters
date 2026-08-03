// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract LaborEquilibrium {
    address public immutable sovereignArchitect;
    
    enum CompanyTier { NONE, TIER1_MEGACORP, TIER2_MIDSIZE, TIER3_SME }
    
    struct Company {
        CompanyTier tier;
        bool isAuditedAndClear;
        uint256 baseWageRequirement;
        uint256 taxCreditsBalance;
    }
    
    mapping(address => Company) public companies;

    constructor() {
        sovereignArchitect = msg.sender;
    }

    function registerCompany(address _company, CompanyTier _tier, uint256 _initialWage) external {
        companies[_company] = Company({
            tier: _tier,
            isAuditedAndClear: true,
            baseWageRequirement: _initialWage,
            taxCreditsBalance: 0
        });
    }

    function executeWageHike(address _company, uint256 _increaseAmount) external {
        companies[_company].baseWageRequirement += _increaseAmount;
        
        // SME Protection: Bigyan ng tax credits kapag nag-hike
        if (companies[_company].tier == CompanyTier.TIER3_SME) {
            companies[_company].taxCreditsBalance += _increaseAmount;
        }
    }
}

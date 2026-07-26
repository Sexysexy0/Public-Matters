// NegativeListValidator.sol
pragma solidity ^0.8.0;

contract NegativeListValidator {
    mapping(string => uint256) public equityLimit; // 0 to 100%

    // Updated April 17, 2026: Setting rules for global capital
    function setIndustryRule(string memory _sector, uint256 _maxForeignEquity) public {
        // Logic: 0% for Mass Media, 100% for Renewable Energy [PSA 2026]
        equityLimit[_sector] = _maxForeignEquity;
    }

    function checkEligibility(string memory _sector, uint256 _intent) public view returns (bool) {
        return _intent <= equityLimit[_sector];
    }
}

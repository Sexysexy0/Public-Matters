// EthicalAutomationLink.sol
// Logic: Taxing Robots to Fund Worker Retraining
pragma solidity ^0.8.0;

contract EthicalAutomationLink {
    uint256 public robotTaxRate = 15; // 15% of savings go to displaced workers

    function calculateUpskillFund(uint256 _laborSavings) public view returns (uint256) {
        return (_laborSavings * robotTaxRate) / 100;
    }
}
